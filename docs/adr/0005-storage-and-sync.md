# ADR 0005: Storage and sync

Status: Accepted

## Context
Need durable local storage, fast full-text search, and optional cross-device sync.

## Decision
* Audio as files (CAF chunks while recording, M4A final) under Application Support.
* Metadata and transcripts in SQLite via GRDB with an FTS5 virtual table. Canonical `transcript.json` kept alongside audio for portability.
* Sync with CloudKit private database (custom zone) and `CKAsset` for audio. Optional user-owned S3 backup later.

## Consequences
* SwiftData was considered; GRDB chosen for FTS5, explicit migrations and testability on Linux.
* CloudKit means no server to run and no data on our infrastructure.
