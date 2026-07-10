# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Personal site: hero/projects/contact homepage, a markdown blog, and "the box" (an empty page reserved for future mini-projects).

## Stack & commands

Static Astro v5 site (`output: 'static'`), TypeScript strict. Local dev uses `direnv` + `shell.nix` (nix shell provides `nodejs`; the shell aliases `run` to `npm run`).

- `npm run dev` — dev server at localhost:4321
- `npm run build` — production build to `./dist`
- `npm run preview` — preview a production build locally
- `npm run astro -- check` — type-check `.astro` files (there is no linter or test suite in this repo — this is the only automated check available)

Deployed via Docker/nginx to a self-hosted Hetzner VPS (see `Dockerfile`, `docker-compose.yml`).

## Deploy & branch workflow

**Never push or merge to `main` directly.** Always work on a feature branch and open a PR with `gh pr create` for review. This is a standing rule for every session, not a one-time check.

**Work on one PR at a time.** Don't spin up a new branch/PR for every small change — keep adding commits to the current open PR's branch unless directed otherwise (e.g. explicitly asked for something separate, or the current PR has already merged). Similarly, stay working locally on one branch until its PR is merged or directed otherwise.

## Commit, PR & branch convention
- **Commits should be atomic** and grouped logically. A readable commit history is important when it comes to reviewing PRs.
- **Commit messages and PR titles** follow [Conventional Commits](https://www.conventionalcommits.org/): `<type>(<scope>): <description>`, e.g. `feat(box): add the box`, `fix(docker): rename app directory`. Common types here: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`. Scope is the affected area (`docker`, `box`, `links`, etc.) and is optional but preferred when it clarifies the change.
- **Branch names** follow the same `<type>/<kebab-case-description>` shape, e.g. `feat/v1`, `fix/docker-port`. Reuse the same type vocabulary as commits.
- **Every commit includes Claude as co-author** (the standard `Co-Authored-By:` trailer) — don't suppress attribution for this repo.

