# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Jack's personal site: hero/projects/contact homepage, a markdown blog, and "the box" (an empty page reserved for future mini-projects).

## Stack & commands

Static Astro v5 site (`output: 'static'`), TypeScript strict. Local dev uses `direnv` + `shell.nix` (nix shell provides `nodejs`; the shell aliases `run` to `npm run`).

- `npm run dev` — dev server at localhost:4321
- `npm run build` — production build to `./dist`
- `npm run preview` — preview a production build locally
- `npm run astro -- check` — type-check `.astro` files (there is no linter or test suite in this repo — this is the only automated check available)

Deployed via Docker/nginx to a self-hosted Hetzner VPS (see `Dockerfile`, `docker-compose.yml`).

## Architecture

- **Routing is file-based** under `src/pages/`: `index.astro` → `/`, `blog/index.astro` → `/blog`, `the-box/index.astro` → `/the-box`. `blog/[slug].astro` is the one dynamic route — it calls `getStaticPaths` + `getCollection('blog')` to pre-render one page per non-draft post at build time (static output, no server-side rendering of routes).
- **Content collections** (`src/content.config.ts`) define the blog schema (`title`, `description`, `pubDate`, `updatedDate?`, `tags`, `draft`) validated against markdown files in `src/content/blog/`. Both `blog/index.astro` (listing) and `blog/[slug].astro` (detail, via `render(post)`) read from this collection through `astro:content` — there's no other data source for post content.
- **`Layout.astro`** (`src/layouts/Layout.astro`) is the single shared page shell every route wraps in: it imports `global.css`, renders `<Fonts />`, `<Header />`, the page's `<slot />`, then `<Footer />`, and sets per-page `<title>`/description meta via props. Global chrome components live under `src/layouts/components/`.
- **Site data is centralized**, not scattered across components: `projects`, `socialLinks`, and `theBox` (typed via `Project`/`SocialLink` in `src/config/site.ts`) are the single source for anything rendered as a list on the homepage or "the box" page. Some entries are still placeholder content pending real data.
- **Styling** is plain CSS with custom properties (`--color-*`, `--space-*`, `--text-*`, `--weight-*` defined in `src/styles/global.css`) processed by a small PostCSS pipeline (`postcss.config.cjs`: `postcss-simple-vars`, `postcss-nested`, `autoprefixer`, `cssnano`). Components use per-file `<style>` blocks with BEM-ish nesting (`&__element`) — no component/CSS framework, no Tailwind, no CSS modules.

## Deploy & branch workflow

Pushing to `main` triggers a GitHub Actions workflow that rsyncs the repo to the VPS and runs `docker compose up -d` — **merging to `main` is an immediate live production deploy**, not staged.

**Never push or merge to `main` directly.** Always work on a feature branch and open a PR with `gh pr create` for Jack to review and comment on; Jack merges when ready. This is a standing rule for every session, not a one-time check.

**Work on one PR at a time.** Don't spin up a new branch/PR for every small change — keep adding commits to the current open PR's branch unless Jack directs otherwise (e.g. explicitly asks for something separate, or the current PR has already merged).

## Commit, PR & branch conventions

- **Commit messages and PR titles** follow [Conventional Commits](https://www.conventionalcommits.org/): `<type>(<scope>): <description>`, e.g. `feat(box): add the box`, `fix(docker): rename app directory`. Common types here: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`. Scope is the affected area (`docker`, `cd`, `box`, `links`, etc.) and is optional but preferred when it clarifies the change.
- **Branch names** follow the same `<type>/<kebab-case-description>` shape, e.g. `feat/v1`, `fix/docker-port`. Reuse the same type vocabulary as commits.
- **Every commit includes Claude as co-author** (the standard `Co-Authored-By:` trailer) — don't suppress attribution for this repo.

## Visual verification

For any change touching CSS, layout, or `.astro` components: start `npm run dev` and actually look at the affected page in a browser before considering the change done. Type-check/build passing does not mean it looks right.

## GitHub Actions integration

`.github/workflows/claude.yml` runs the Claude Code GitHub Action (needs the `CLAUDE_CODE_OAUTH_TOKEN` secret), triggered by `@claude` mentions in issue comments, PR review comments, PR reviews, or new issues — a second, independent entry point into this repo alongside local sessions.

There's deliberately no automated review-on-PR workflow: it would just have Claude reviewing code that Claude already wrote and reviewed in-session, with no independent signal added.
