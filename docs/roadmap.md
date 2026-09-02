# Ride Replay — Project Roadmap

> **Working title:** Ride Replay  
> **Goal:** Visualise snowboard GPS trails on mountain terrain (2D first, 3D optional).  
> **House rules:** [house-rules.md](house-rules.md) — read before starting any task.  
> **Progress:** Check boxes as each task's PR is merged to `main`.

---

## How to use this roadmap

1. Pick the next unchecked task in order (or within a phase if prerequisites are done).
2. Create branch `task/<id>-<slug>` (see [house-rules §3](house-rules.md#3-branching-strategy)).
3. Write feature spec → failing tests → implement → journal → PR.
4. Mark `[x]` here when [Definition of Done](house-rules.md#7-definition-of-done-per-task) is met.

**Legend:** `TDD` = tests before implementation | `DOC` = journal entry required (includes **Explain it**) | `VIS` = manual visual check

---



## Progress overview


| Phase | Description                   | Progress |
| ----- | ----------------------------- | -------- |
| 0     | Environment & CI              | 5 / 8    |
| 1     | GPX ingestion                 | 0 / 10   |
| 2     | Geo math                      | 0 / 9    |
| 3     | 2D topo map (**Tier 1**)      | 0 / 11   |
| 4     | OpenGL bootstrap              | 0 / 8    |
| 5     | 3D terrain mesh               | 0 / 9    |
| 6     | Trail in 3D (**Tier 2**)      | 0 / 7    |
| 7     | Polish (**Tier 3**, optional) | 0 / 5    |


---



## Tier milestones

- [ ] **Tier 1 complete** — Phases 0–3 done; 2D PNG from real GPX
- [ ] **Tier 2 complete** — Phases 4–6 done; interactive 3D view
- [ ] **Tier 3** — Phase 7 features as desired

---



## Phase 0 — Environment & CI

**Goal:** Repo compiles, tests run, CI blocks bad merges from day one.

### 0-01 · Create repository scaffold `chore`

- [x] Create `ride-replay` repo (local at `~/ride-replay`)
- [x] Add root `CMakeLists.txt` with C++20 standard
- [x] Add `include/ride/` and `src/` directory structure
- [x] Add `.gitignore` (`build/`, `output/`, `assets/gpx/*.gpx`, large heightmaps)



### 0-02 · GoogleTest wiring `chore` `TDD`

- [x] Add GoogleTest via CMake `FetchContent`
- [x] Add `tests/` target linked to gtest
- [x] Add smoke test `SmokeTest_ProjectConfig_IsValid` that passes
- [x] Verify `ctest` runs from build directory



### 0-03 · CLI entry point `feat`

- [x] Add `src/main.cpp` with `--help` flag
- [x] Add CMake executable target `ride_replay`
- [x] Document build/run in `README.md`



### 0-04 · Code formatting `chore`

- [x] Add `.clang-format` (LLVM style, project-tuned)
- [x] Format all existing files
- [x] Document `clang-format` usage in README



### 0-05 · CI pipeline — build & test `chore`

- [ ] Add `.github/workflows/ci.yml`
- [ ] Job: CMake configure + build (Debug)
- [ ] Job: `ctest --output-on-failure`
- [ ] Enable branch protection on `main` requiring CI pass



### 0-06 · CI pipeline — format check `chore`

- [ ] Add `format` job: `clang-format --dry-run -Werror`
- [ ] Add to required status checks



### 0-07 · CI pipeline — documentation check `chore`

- [ ] Add `scripts/check-docs.sh` (public headers must have `@brief`)
- [ ] Add `docs` job to CI workflow
- [ ] Add to required status checks



### 0-08 · PR template & docs folders `chore` `DOC`

- [x] Add `.github/pull_request_template.md` (self-review checklist)
- [x] Create `docs/specs/`, `docs/journal/`
- [ ] Write journal entry: `docs/journal/YYYY-MM-DD-0-08-project-kickoff.md`

**Phase 0 exit:** CI green on `main`; smoke test passes; house rules in repo.

---



## Phase 1 — GPX ingestion

**Goal:** Parse a real Strava GPX; print stats in terminal.

### 1-01 · TrackPoint type `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-01-track-point.md`
- [ ] Define `TrackPoint` struct: `lat`, `lon`, `ele`, `timestamp`
- [ ] Test: default / constructed values
- [ ] Add `@brief` documentation on public type
- [ ] Journal entry



### 1-02 · XML dependency `chore` `DOC`

- [ ] Note library choice in journal (pugixml vs tinyxml2)
- [ ] Add chosen library via CMake FetchContent or submodule
- [ ] Verify linking in build
- [ ] Journal entry (why this library)



### 1-03 · Parse single track point `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-03-gpx-trkpt.md`
- [ ] Add test fixture: `tests/fixtures/minimal_track.gpx`
- [ ] Test: `ParsesSingleTrkpt_ReturnsCorrectLatLon`
- [ ] Test: `ParsesTrkptWithElevation_ReturnsEle`
- [ ] Test: `ParsesTrkptWithTime_ReturnsTimestamp`
- [ ] Implement parser for single `<trkpt>`
- [ ] Journal entry



### 1-04 · Parse full track `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-04-gpx-full-track.md`
- [ ] Test: `ParsesMultipleTrkpts_ReturnsCorrectCount`
- [ ] Test: `EmptyTrkseg_ReturnsEmptyVector`
- [ ] Test: `MalformedXml_ReturnsError` (or throws — document choice)
- [ ] Implement multi-point track parsing
- [ ] Journal entry



### 1-05 · Track bounds `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-05-track-bounds.md`
- [ ] Test: `ComputeBounds_SinglePoint_ReturnsSameMinMax`
- [ ] Test: `ComputeBounds_MultiplePoints_ReturnsCorrectBox`
- [ ] Implement min/max lat/lon (and optional ele bounds)
- [ ] Journal entry



### 1-06 · Track duration `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-06-track-duration.md`
- [ ] Test: `ComputeDuration_KnownTimestamps_ReturnsCorrectSeconds`
- [ ] Test: `ComputeDuration_MissingTimestamps_HandlesGracefully`
- [ ] Implement duration from first/last timestamp
- [ ] Journal entry



### 1-07 · GpxTrack aggregate `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-07-gpx-track.md`
- [ ] Define `GpxTrack` class wrapping `vector<TrackPoint>` + metadata
- [ ] Test: load fixture and query point count, bounds, duration
- [ ] Journal entry



### 1-08 · CLI — stats command (point count) `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/1-08-cli-stats.md`
- [ ] Test: CLI integration test or parser dispatch unit test
- [ ] Implement `ride_replay stats <file.gpx>` → prints point count
- [ ] Manual test with real Strava export
- [ ] Journal entry



### 1-09 · CLI — stats bounds & duration `feat` `TDD` `DOC`

- [ ] Extend stats output: bounds, duration
- [ ] Test: output formatting with known fixture
- [ ] Manual compare rough values to Strava for one ride
- [ ] Journal entry



### 1-10 · Phase 1 cleanup `chore` `DOC`

- [ ] Review all public API docs
- [ ] Ensure ≥8 tests in GPX-related test files
- [ ] Update README with `stats` example
- [ ] Journal entry: Phase 1 retrospective

**Phase 1 exit:** `ride_replay stats my-ride.gpx` works on real GPX.

---



## Phase 2 — Geo math

**Goal:** Convert lat/lon to local metres; compute distance and elevation gain.

### 2-01 · Degrees ↔ radians helpers `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-01-angle-utils.md`
- [ ] Test: known conversion values (`EXPECT_NEAR`)
- [ ] Implement `to_radians` / `to_degrees`
- [ ] Journal entry



### 2-02 · Haversine distance `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-02-haversine.md`
- [ ] Test: known distance (e.g. Christchurch ↔ specific point, ±1 m)
- [ ] Test: zero distance for identical points
- [ ] Implement `haversine_meters(lat1, lon1, lat2, lon2)`
- [ ] Journal entry



### 2-03 · Local projection anchor `feat` `TDD` `DOC`

- [ ] Note projection choice in journal (equirectangular vs UTM)
- [ ] Write spec `docs/specs/2-03-projection.md`
- [ ] Test: anchor at centroid; origin maps to (0,0)
- [ ] Implement `LocalProjection` class (anchor lat/lon)
- [ ] Journal entry



### 2-04 · Project point to local metres `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-04-project-point.md`
- [ ] Test: point north of anchor has positive y
- [ ] Test: point east of anchor has positive x
- [ ] Implement `project(lat, lon) → (x, y)`
- [ ] Journal entry



### 2-05 · Project full track `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-05-project-track.md`
- [ ] Test: N points → N local `(x,y)` pairs
- [ ] Implement `project_track(GpxTrack) → vector<LocalPoint>`
- [ ] Journal entry



### 2-06 · Track total distance `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-06-track-distance.md`
- [ ] Test: straight line / known path length
- [ ] Implement sum of haversine segments along track
- [ ] Journal entry



### 2-07 · Elevation gain `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-07-elevation-gain.md`
- [ ] Test: monotonic climb / descent / flat
- [ ] Implement elevation gain (ignore descent in total gain)
- [ ] Journal entry



### 2-08 · Trail aggregate class `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/2-08-trail.md`
- [ ] Define `Trail` class: local points, distance, elev gain, bounds
- [ ] Test: build from `GpxTrack` + `LocalProjection`
- [ ] Journal entry



### 2-09 · CLI — extended stats `feat` `TDD` `DOC`

- [ ] Extend `stats` with distance (m) and elevation gain (m)
- [ ] Test: formatted output
- [ ] Manual compare to Strava (±5% acceptable — document why)
- [ ] Journal entry: Phase 2 retrospective

**Phase 2 exit:** Stats match Strava roughly; local coordinates exist for trail.

---



## Phase 3 — 2D topographic map (Tier 1 finish)

**Goal:** PNG with terrain shading + trail overlay.

### 3-01 · Heightmap load `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-01-heightmap-load.md`
- [ ] Add `stb_image` via CMake
- [ ] Test fixture: tiny synthetic heightmap PNG in `tests/fixtures/`
- [ ] Test: `LoadHeightmap_ValidPng_ReturnsCorrectDimensions`
- [ ] Test: `LoadHeightmap_MissingFile_ReturnsError`
- [ ] Implement `Heightmap` class (width, height, `sample(x,y)`)
- [ ] Journal entry



### 3-02 · Heightmap normalisation `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-02-heightmap-normalise.md`
- [ ] Test: pixel value maps to height in metres (configurable scale)
- [ ] Implement min/max or scale factor from metadata / constructor
- [ ] Journal entry



### 3-03 · Geographic bounds sidecar `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-03-bounds-sidecar.md`
- [ ] Define JSON format: SW/NE lat/lon corners for heightmap
- [ ] Test: parse bounds file
- [ ] Implement `HeightmapBounds` + load from `.json`
- [ ] Journal entry



### 3-04 · Map trail to heightmap grid `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-04-trail-to-grid.md`
- [ ] Test: known local point → correct pixel `(px, py)`
- [ ] Implement `trail_to_pixel_coords(Trail, HeightmapBounds)`
- [ ] Journal entry



### 3-05 · Colour-by-elevation `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-05-elevation-colour.md`
- [ ] Test: low pixel → colour A, high pixel → colour B
- [ ] Implement elevation → RGB gradient (no external images)
- [ ] Journal entry



### 3-06 · Hillshade (optional upgrade) `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-06-hillshade.md`
- [ ] Test: slope direction affects brightness
- [ ] Implement simple hillshade from height gradient
- [ ] Journal entry



### 3-07 · Draw polyline on image buffer `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-07-draw-polyline.md`
- [ ] Test: two-pixel line connects endpoints
- [ ] Test: line outside bounds clipped or ignored
- [ ] Implement Bresenham (or equivalent) on RGB buffer
- [ ] Journal entry



### 3-08 · Compose terrain + trail image `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/3-08-compose-map.md`
- [ ] Test: output buffer dimensions match heightmap
- [ ] Implement `render_map(Heightmap, Trail, bounds) → ImageBuffer`
- [ ] Journal entry



### 3-09 · PNG export `feat` `TDD` `DOC`

- [ ] Add `stb_image_write`
- [ ] Test: write PNG, re-read dimensions
- [ ] Implement `write_png(path, ImageBuffer)`
- [ ] Journal entry



### 3-10 · CLI — map command `feat` `TDD` `DOC` `VIS`

- [ ] Write spec `docs/specs/3-10-cli-map.md`
- [ ] Implement `ride_replay map --heightmap hm.png --bounds hm.json --gpx ride.gpx -o out.png`
- [ ] Manual test: recognisable trail on terrain
- [ ] Add sample output image to README (synthetic data if privacy concern)
- [ ] Journal entry



### 3-11 · Tier 1 completion `chore` `DOC` `VIS`

- [ ] Manual test with real snowboard GPX + heightmap for a field you ride
- [ ] Verify ≥20 total unit tests across project
- [ ] Update README resume blurb
- [ ] Journal entry: Tier 1 retrospective — would you show this to an employer?

**Tier 1 exit:** Real ride visible on 2D topo PNG; tagged release.

---



## Phase 4 — OpenGL bootstrap

**Goal:** Understand GPU pipeline in isolation before terrain.

### 4-01 · GLFW + GL loader `feat` `DOC` `VIS`

- [ ] Note toolchain choice in journal (GLFW, loader)
- [ ] Write spec `docs/specs/4-01-glfw-window.md`
- [ ] Add GLFW + glad (or gl3w) via CMake
- [ ] Open blank window; close on ESC
- [ ] Manual test: window opens and closes cleanly
- [ ] Journal entry



### 4-02 · Shader compile utility `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/4-02-shader-compile.md`
- [ ] Test: valid shader source compiles (headless or test context if feasible)
- [ ] Test: invalid shader returns error message with line hint
- [ ] Implement `ShaderProgram` RAII wrapper
- [ ] Journal entry



### 4-03 · Render triangle `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/4-03-triangle.md`
- [ ] Vertex + fragment shaders (solid colour)
- [ ] VBO/VAO setup
- [ ] Manual test: coloured triangle on screen
- [ ] Journal entry: explain vertex → fragment pipeline in your own words



### 4-04 · Shader from files `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/4-04-shader-files.md`
- [ ] Load `.vert` / `.frag` from `assets/shaders/`
- [ ] Test: file not found → clear error
- [ ] Journal entry



### 4-05 · Render loop + delta time `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/4-05-render-loop.md`
- [ ] Poll events; stable loop timing
- [ ] Manual test: window remains responsive
- [ ] Journal entry



### 4-06 · glm integration `feat` `TDD` `DOC`

- [ ] Add glm via CMake
- [ ] Test: matrix multiply known result
- [ ] Journal entry



### 4-07 · Basic perspective camera `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/4-07-camera-mvp.md`
- [ ] Apply MVP to triangle; animate slow rotation
- [ ] Manual test checklist updated
- [ ] Journal entry



### 4-08 · Phase 4 retrospective `chore` `DOC`

- [ ] All GL object wrappers use RAII (document in journal)
- [ ] Journal entry: hardest part of OpenGL so far

**Phase 4 exit:** You can explain VBO/VAO/shaders; triangle renders reliably.

---



## Phase 5 — 3D terrain mesh

**Goal:** Heightmap becomes lit, rotatable 3D terrain.

### 5-01 · Heightmap → vertex grid `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/5-01-terrain-vertices.md`
- [ ] Test: W×H heightmap → W×H vertices with correct x,y,z
- [ ] Implement `TerrainMesh::from_heightmap`
- [ ] Journal entry



### 5-02 · Index buffer (triangles) `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/5-02-terrain-indices.md`
- [ ] Test: (W-1)×(H-1)×2 triangles; correct vertex indices
- [ ] Implement index generation
- [ ] Journal entry



### 5-03 · Vertex normals `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/5-03-terrain-normals.md`
- [ ] Test: flat plateau → normal points up
- [ ] Test: east-facing slope → normal points west (adjust for coord system)
- [ ] Implement normal calculation
- [ ] Journal entry



### 5-04 · Upload mesh to GPU `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/5-04-mesh-gpu.md`
- [ ] VBO/VAO/EBO for terrain
- [ ] Manual test: point cloud or wireframe visible
- [ ] Journal entry



### 5-05 · Terrain shaders `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/5-05-terrain-shaders.md`
- [ ] Diffuse lighting using normals
- [ ] Manual test: terrain looks 3D not flat
- [ ] Journal entry



### 5-06 · Orbit camera (mouse) `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/5-06-orbit-camera.md`
- [ ] Drag to rotate; optional scroll zoom
- [ ] Manual test: orbit feels smooth
- [ ] Journal entry



### 5-07 · Scale terrain to world units `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/5-07-terrain-scale.md`
- [ ] Test: heightmap metres match `HeightmapBounds` width
- [ ] Apply same projection scale as trail
- [ ] Journal entry



### 5-08 · Wireframe toggle `feat` `DOC` `VIS`

- [ ] Press key to toggle wireframe (debug aid)
- [ ] Journal entry



### 5-09 · Phase 5 retrospective `chore` `DOC` `VIS`

- [ ] Terrain only (no trail) spins smoothly
- [ ] Journal entry: mesh pipeline end-to-end

**Phase 5 exit:** Grey terrain, orbit camera, lit slopes.

---



## Phase 6 — Trail in 3D (Tier 2 finish)

**Goal:** GPX trail draped on terrain; interactive view command.

### 6-01 · Sample height at local (x,y) `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/6-01-sample-height.md`
- [ ] Test: bilinear or nearest sample on heightmap
- [ ] Implement `Heightmap::height_at_local(x, y)`
- [ ] Journal entry



### 6-02 · Snap trail to terrain `feat` `TDD` `DOC`

- [ ] Note snap vs GPX elevation choice in journal
- [ ] Write spec `docs/specs/6-02-snap-trail.md`
- [ ] Test: known (x,y) → z from heightmap not GPX ele
- [ ] Implement `snap_trail_to_terrain(Trail, Heightmap)`
- [ ] Journal entry



### 6-03 · Trail 3D vertex buffer `feat` `TDD` `DOC`

- [ ] Write spec `docs/specs/6-03-trail-vertices.md`
- [ ] Test: N trail points → 3N floats
- [ ] Build GPU buffer for `GL_LINE_STRIP`
- [ ] Journal entry



### 6-04 · Render trail line `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/6-04-render-trail.md`
- [ ] Contrasting colour shader (e.g. red on grey terrain)
- [ ] Manual test: line visible on slope
- [ ] Journal entry



### 6-05 · Frame camera on trail `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/6-05-frame-camera.md`
- [ ] On load, camera targets trail centroid and bounds
- [ ] Manual test: opens framed on run
- [ ] Journal entry



### 6-06 · CLI — view command `feat` `DOC` `VIS`

- [ ] Write spec `docs/specs/6-06-cli-view.md`
- [ ] Implement `ride_replay view --heightmap ... --bounds ... --gpx ...`
- [ ] Manual test with real ride
- [ ] Journal entry



### 6-07 · Tier 2 completion `chore` `DOC` `VIS`

- [ ] Record screenshot or short screen capture for README
- [ ] Journal entry: Tier 2 retrospective

**Tier 2 exit:** Interactive 3D view of real snowboard run.

---



## Phase 7 — Polish (Tier 3, optional)

Pick any order. Each is its own task branch.

### 7-01 · Speed-coloured trail `feat` `TDD` `DOC` `VIS`

- [ ] Write spec
- [ ] Compute speed from timestamp + distance per segment
- [ ] Map speed → colour gradient on trail
- [ ] Tests for speed calculation
- [ ] Journal entry



### 7-02 · Camera replay along trail `feat` `DOC` `VIS`

- [ ] Write spec
- [ ] Animate camera position by timestamp along trail
- [ ] Manual test checklist
- [ ] Journal entry



### 7-03 · Multiple GPX overlay `feat` `TDD` `DOC` `VIS`

- [ ] Write spec
- [ ] Load N trails; distinct colours
- [ ] Journal entry



### 7-04 · Real DEM via GDAL `feat` `DOC`

- [ ] Note build complexity tradeoff in journal
- [ ] Load GeoTIFF for NZ ski field region



### 7-05 · Export fly-through frames `feat` `DOC` `VIS`

- [ ] Write spec
- [ ] Save PNG sequence from replay camera
- [ ] Journal entry

---



## Learning outcomes (project-level)

Mark when you can do it **without AI-generated code**:

- [ ] Build and test with CMake from scratch on a fresh machine
- [ ] Explain `const&`, `unique_ptr`, and when copies happen
- [ ] Write a failing GoogleTest and implement to green
- [ ] Parse XML into typed C++ structures
- [ ] Project lat/lon to local metres and justify error margin
- [ ] Describe OpenGL render pipeline (Tier 2)
- [ ] Walk an interviewer through GPX → 3D trail (Tier 2)

---



## Resume blurbs

**Tier 1:**

> **Ride Replay (C++)** — GPX trail parser and topographic map renderer. Coordinate projection, heightmap terrain, TDD with GoogleTest, CI with GitHub Actions. CMake.

**Tier 2:**

> **Ride Replay (C++)** — 3D terrain visualiser for GPS snowboard tracks. GPX parsing, mesh generation, OpenGL rendering, GLFW. Documented architecture decisions, test-driven development.

---



## Reference


| Doc                              | Purpose                                |
| -------------------------------- | -------------------------------------- |
| [house-rules.md](house-rules.md) | Branching, TDD, AI policy, CI, DoD     |
| [docs/specs/](specs/)            | Per-task feature specs                 |
| [docs/journal/](journal/)        | Your learning log + Explain it entries |


---

*Last updated: 2026-08-30 — checkbox roadmap + house rules integrated.*