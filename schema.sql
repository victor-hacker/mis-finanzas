-- Ejecutar en Supabase > SQL Editor. Datos privados por usuario.
create table if not exists public.finance_app_state (
 user_id uuid primary key references auth.users(id) on delete cascade,
 data jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);
alter table public.finance_app_state enable row level security;
revoke all on public.finance_app_state from anon;
grant select, insert, update, delete on public.finance_app_state to authenticated;
drop policy if exists "finance_state_owner" on public.finance_app_state;
create policy "finance_state_owner" on public.finance_app_state
 for all to authenticated using ((select auth.uid()) = user_id)
 with check ((select auth.uid()) = user_id);
