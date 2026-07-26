-- ============================================================
-- 실험 데이터 공유 커뮤니티 — Supabase 초기 설정 SQL
-- Supabase 대시보드 → SQL Editor → New query 에 전체를 붙여넣고 Run
-- ============================================================

-- 게시글 테이블: 데이터(CSV) + 설명글을 하나의 "게시글"로 저장
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  author_name text not null,
  title text not null,
  description text,
  tag text default '기타',
  csv_text text not null,
  created_at timestamptz default now()
);

-- Row Level Security 활성화 (이게 있어야 남의 글을 함부로 수정/삭제 못 함)
alter table public.posts enable row level security;

-- 아무나(로그인 안 해도) 게시글을 읽을 수 있음 — 공개 피드
create policy "누구나 게시글 읽기 가능"
  on public.posts for select
  using (true);

-- 로그인한 사용자만, 본인 이름으로만 글 작성 가능
create policy "로그인한 사용자만 작성 가능"
  on public.posts for insert
  to authenticated
  with check (auth.uid() = user_id);

-- 작성자 본인만 수정 가능
create policy "작성자만 수정 가능"
  on public.posts for update
  to authenticated
  using (auth.uid() = user_id);

-- 작성자 본인만 삭제 가능
create policy "작성자만 삭제 가능"
  on public.posts for delete
  to authenticated
  using (auth.uid() = user_id);

-- 최신 글이 먼저 보이도록 인덱스
create index if not exists posts_created_at_idx on public.posts (created_at desc);
