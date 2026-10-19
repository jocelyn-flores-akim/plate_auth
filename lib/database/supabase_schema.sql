-- CHU Hospital Database Schema for Supabase

-- Users table (uses Supabase Auth)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  full_name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('admin', 'agent', 'doctor', 'nurse')),
  service_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  is_active BOOLEAN DEFAULT true
);

-- Patients table
CREATE TABLE IF NOT EXISTS patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id VARCHAR(50) NOT NULL UNIQUE, -- PAT-2024-000123 format
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  phone_number VARCHAR(20),
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Buildings table
CREATE TABLE IF NOT EXISTS buildings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  floors_count INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wings table (Ailes - per floor per building)
CREATE TABLE IF NOT EXISTS wings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL, -- Est, Ouest, Nord, Sud
  floor VARCHAR(50) NOT NULL, -- RDC, 1er étage, 2ème étage
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(building_id, floor, name)
);

-- Rooms table (Chambres)
CREATE TABLE IF NOT EXISTS rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wing_id UUID NOT NULL REFERENCES wings(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL, -- Chambre 101, 102, etc.
  service VARCHAR(100) NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 1, -- Number of beds
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Beds table
CREATE TABLE IF NOT EXISTS beds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  bed_number VARCHAR(50) NOT NULL, -- Lit 1, Lit A, etc.
  bed_type VARCHAR(50) NOT NULL CHECK (bed_type IN ('standard', 'bariatric', 'pediatric', 'intensive')),
  status VARCHAR(50) NOT NULL CHECK (status IN ('available', 'occupied', 'cleaning')) DEFAULT 'available',
  current_patient_id UUID REFERENCES patients(id) ON DELETE SET NULL,
  admission_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(room_id, bed_number)
);

-- Admissions table
CREATE TABLE IF NOT EXISTS admissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  bed_id UUID NOT NULL REFERENCES beds(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES users(id),
  service VARCHAR(100) NOT NULL,
  reason TEXT NOT NULL,
  notes TEXT,
  status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'discharged', 'transferred')) DEFAULT 'active',
  admission_date TIMESTAMP NOT NULL,
  discharge_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical Records table (for future use)
CREATE TABLE IF NOT EXISTS medical_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admission_id UUID NOT NULL REFERENCES admissions(id) ON DELETE CASCADE,
  record_type VARCHAR(100),
  file_url TEXT,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by UUID REFERENCES users(id)
);

-- Activity Logs table
CREATE TABLE IF NOT EXISTS activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  action VARCHAR(255) NOT NULL,
  table_name VARCHAR(100),
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_patients_full_name ON patients(first_name, last_name);
CREATE INDEX idx_patients_patient_id ON patients(patient_id);
CREATE INDEX idx_beds_room_id ON beds(room_id);
CREATE INDEX idx_beds_status ON beds(status);
CREATE INDEX idx_beds_current_patient ON beds(current_patient_id);
CREATE INDEX idx_admissions_patient_id ON admissions(patient_id);
CREATE INDEX idx_admissions_doctor_id ON admissions(doctor_id);
CREATE INDEX idx_admissions_status ON admissions(status);
CREATE INDEX idx_admissions_admission_date ON admissions(admission_date);
CREATE INDEX idx_rooms_service ON rooms(service);
CREATE INDEX idx_wings_building_id ON wings(building_id);

-- Enable RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE wings ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE beds ENABLE ROW LEVEL SECURITY;
ALTER TABLE admissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Users: Only admins can view all, others see themselves
CREATE POLICY users_view ON users FOR SELECT
  USING (auth.uid() = id OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY users_update ON users FOR UPDATE
  USING (auth.uid() = id OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- Patients: All authenticated users can view
CREATE POLICY patients_view ON patients FOR SELECT
  USING (auth.role() = 'authenticated');

-- Beds: All authenticated users can view
CREATE POLICY beds_view ON beds FOR SELECT
  USING (auth.role() = 'authenticated');

-- Admissions: Users can view their own, doctors see their patients, admins see all
CREATE POLICY admissions_view ON admissions FOR SELECT
  USING (
    doctor_id = auth.uid() OR
    (SELECT role FROM users WHERE id = auth.uid()) = 'admin' OR
    (SELECT id FROM users WHERE id = auth.uid() AND role = 'agent')
  );
