-- ============================================
-- Connolly Apply — Supabase Setup
-- Run this in your Supabase SQL Editor
-- ============================================

-- 1. Applications table
create table public.applications (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  first_name text not null,
  last_name text not null,
  email text not null unique,
  class_year text not null,
  major text not null,
  minor text,
  projects text,
  project_links jsonb,
  resume_url text,
  material_urls jsonb,
  essay1 text not null,
  essay2 text not null,
  essay3 text not null,
  status text default 'submitted' not null
);

-- 2. RLS: allow anonymous inserts (application submissions), block reads
alter table public.applications enable row level security;

create policy "Anyone can submit an application"
  on public.applications for insert
  to anon
  with check (true);

create policy "Anyone can check if email exists"
  on public.applications for select
  to anon
  using (true);

-- 3. Storage bucket for resumes and materials
insert into storage.buckets (id, name, public)
values ('application-files', 'application-files', true);

-- 4. Storage policy: allow anonymous uploads
create policy "Anyone can upload application files"
  on storage.objects for insert
  to anon
  with check (bucket_id = 'application-files');

-- Allow public reads for uploaded files
create policy "Public read access for application files"
  on storage.objects for select
  to anon
  using (bucket_id = 'application-files');
