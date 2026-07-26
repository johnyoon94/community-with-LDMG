# 실험 데이터 공유 커뮤니티

로그인한 사용자가 실험 데이터(CSV)와 설명글을 함께 올리고, 누구나 그 글을 읽고
차트로 볼 수 있는 커뮤니티 사이트입니다. 서버 코드 없이 정적 파일 + Supabase(무료
백엔드 서비스)로 동작합니다.

## 1. Supabase 프로젝트 만들기 (5분)

1. https://supabase.com 에서 무료 계정 가입 후 **New project** 생성
2. 프로젝트가 만들어지면 왼쪽 메뉴 **SQL Editor** → **New query**
3. 이 폴더의 `supabase-setup.sql` 내용 전체를 복사해서 붙여넣고 **Run**
   (posts 테이블과 보안 규칙이 자동으로 만들어집니다)
4. 왼쪽 메뉴 **Settings → API** 로 이동해서 두 값을 복사해두세요:
   - **Project URL** (예: `https://abcdefgh.supabase.co`)
   - **anon public** 키 (긴 문자열)

## 2. 사이트에 연결하기

`community.html` 파일을 열어서 맨 위쪽 `<script>` 블록을 찾으세요:

```js
const SUPABASE_URL = 'https://YOUR-PROJECT-ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
```

이 두 줄을 방금 복사한 값으로 바꿔서 저장하면 끝입니다.

## 3. 이메일 인증 설정 (선택)

기본값은 가입 시 이메일 인증 링크를 요구합니다. 친구들끼리 편하게 쓰는 용도라면
꺼두는 게 편해요:

Supabase 대시보드 → **Authentication → Providers → Email** →
**Confirm email** 옵션을 끄면, 가입 즉시 로그인되어 바로 글을 쓸 수 있습니다.

## 4. 배포하기

정적 파일이라 어디에나 올릴 수 있어요. 예전에 안내한 방법과 동일합니다:

- **Netlify Drop**: netlify.com/drop 에 이 폴더를 드래그 앤 드롭 → 즉시 공개 URL 생성
- **GitHub Pages**: 저장소에 올리고 Pages 기능 켜기

배포한 주소를 다른 사람들과 공유하면, 그 사람들도 가입하고 데이터를 올릴 수
있습니다.

## 파일 구성

- `community.html` — 전체 앱 (피드, 로그인/가입, 새 글 작성, 게시글 상세)
- `supabase-setup.sql` — 데이터베이스 테이블 + 보안 규칙 생성 스크립트

## 동작 방식 요약

- 누구나(로그인 없이도) 피드의 글을 읽을 수 있습니다.
- 글을 쓰려면 이메일로 간단히 가입/로그인해야 합니다.
- 각 글은 제목, 분류, 설명, CSV 데이터로 구성되고 자동으로 차트가 그려집니다.
- 본인이 쓴 글만 삭제할 수 있습니다 (Supabase의 Row Level Security로 서버단에서
  강제되므로, 다른 사람이 API를 직접 건드려도 우회할 수 없습니다).
- CSV 원본 텍스트는 데이터베이스에 그대로 저장되고, 화면에 보여줄 때마다 브라우저에서
  다시 그래프로 그립니다.

## 주의할 점

- Supabase 무료 요금제에는 데이터베이스 용량·요청 횟수 제한이 있습니다. 개인/소규모
  커뮤니티 용도로는 충분하지만, 사용자가 많아지면 유료 플랜을 고려해야 할 수 있어요.
- 지금은 업로드 파일 크기를 200KB로 제한해두었는데, `community.html`의
  `200 * 1024` 부분을 수정하면 바꿀 수 있습니다.
- 스팸 방지를 위해 이메일 가입을 요구하도록 했지만, 완전한 스팸 차단은 아니므로
  글이 너무 많아지면 Supabase 대시보드의 **Table Editor**에서 직접 삭제할 수 있습니다.
