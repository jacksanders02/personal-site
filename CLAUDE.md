# personal-site

Jack's personal site: hero/projects/contact homepage, a markdown blog, and "the box" (an empty page reserved for future mini-projects).

## Stack & commands

Static Astro v5 site (`output: 'static'`), TypeScript strict. Local dev uses `direnv` + `shell.nix` (nix shell provides `nodejs`; the shell aliases `run` to `npm run`).

- `npm run dev` — dev server at localhost:4321
- `npm run build` — production build to `./dist`
- `npm run preview` — preview a production build locally
- `npm run astro -- check` — type-check `.astro` files

Deployed via Docker/nginx to a self-hosted Hetzner VPS (see `Dockerfile`, `docker-compose.yml`).

## Conventions

- **Content-driven config**: projects, `socialLinks`, and `theBox` entries live in `src/config/site.ts` (typed via `Project`/`SocialLink` interfaces) — don't hardcode this data in pages. Some entries there are still placeholder content (Project Alpha/Beta/Gamma, placeholder social links) pending real data.
- **Blog posts**: markdown files in `src/content/blog/`, schema enforced in `src/content.config.ts` (`title`, `description`, `pubDate`, `updatedDate?`, `tags`, `draft`).
- **Styling**: plain CSS with custom properties (`--color-*`, `--space-*`, `--text-*`, `--weight-*`, defined in `src/styles/global.css`), PostCSS nesting (`&__modifier` BEM-ish style) via `postcss-nested`/`postcss-simple-vars`. No component/CSS framework — match this style rather than introducing one.
- **Global chrome**: `Header.astro`, `Footer.astro`, `Fonts.astro` live under `src/layouts/components/`.

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
