# Session 1 — Velkommen til GameMaker!
### *Bygger et Among Us klon — Del 1 af 4*
**Varighed:** ~75 minutter | **Til hvem:** Totale begyndere (ca. 10 år)

---

## Hvad laver vi? 🚀
Du skal bygge din egen version af **Among Us** — et top-down spil hvor du sniger dig omkring på et rumskib, udfører opgaver og eliminerer besætningsmedlemmer. Ved session 4 har du et helt spilbart spil du selv har lavet!

---

## Tidsplan

| Tid | Aktivitet |
|-----|-----------|
| 0:00 – 0:10 | Hvad er GameMaker? |
| 0:10 – 0:20 | Installer GameMaker + opret konto |
| 0:20 – 0:30 | Opret nyt projekt + importér sprites |
| 0:30 – 0:45 | Rundtur i GameMaker IDE |
| 0:45 – 0:65 | Opsætning af rummet (skib + lag) |
| 0:65 – 0:75 | Tryk Play + fejr det! |

---

## Del 1 — Hvad er GameMaker? (10 min)

GameMaker er en game engine — et program der hjælper dig med at lave spil. Det bruger et sprog kaldet **GML (GameMaker Language)**.

Nogle spil lavet med GameMaker som du måske kender:
- **Undertale**
- **Hotline Miami**
- **Spelunky**

I GameMaker er alt bygget fra disse grundlæggende dele:

| Del | Hvad det er |
|-----|-----------|
| **Sprite** | Et billede (som en karaktertegning) |
| **Object** | En "ting" i dit spil — den har kode som gør at den GØRER noget |
| **Room** | Et level eller en skærm i dit spil |
| **Tileset** | Et ark med små fliser brugt til at tegne vægge og gulve |

---

## Del 2 — Installer GameMaker (10 min)

1. Åbn en webbrowser og gå til: **https://gamemaker.io**
2. Klik **Download** → vælg versionen til dit OS (Windows eller Mac)
3. Installer det som ethvert normalt program
4. Når det åbner, **opret en gratis konto** (du kan bruge en fiktiv email hvis nødvendigt)
5. Log ind — du er klar!

> **Note til læreren:** Den gratis version af GameMaker 2024 har alle funktioner til 2D spil. Ingen køb nødvendig.

---

## Del 3 — Opret nyt projekt + Importér Sprites (10 min)

I stedet for at downloade et færdigt projekt, skal du bygge alt selv. Læreren har uploadet al kunsten til GitHub så du kan hente de billeder du skal bruge.

### Trin 3.1 — Opret nyt projekt
1. I GameMaker, klik **New Project**
2. Vælg **GameMaker Language (GML)**
3. Kald det noget som `AmongUs` og gem det nogle steder der er let at finde (f.eks. dit Skrivebord)

GameMaker laver et tomt projekt med ét tomt room — perfekt.

### Trin 3.2 — Download sprite billederne
1. Gå til GitHub linket som din lærer giver dig
2. Åbn mappen **`sprites/`** — du vil se billedfiler som `the_skeld.png`, `spr_player_idle_down.png` osv.
3. Klik på hver billede du skal bruge → klik på **Download raw file** knappen (eller højreklik → Save image as)
4. Gem dem alle i en mappe, f.eks. `Desktop/AmongUsAssets/`

> **Sprite billeder at downloade i dag:**
> - `the_skeld.png` — rumskibsbaggrunden
> - `spr_player_idle_down.png`, `spr_player_idle_up.png`, `spr_player_idle_left.png`, `spr_player_idle_right.png`
> - `spr_player_walk_down.png`, `spr_player_walk_up.png`, `spr_player_walk_left.png`, `spr_player_walk_right.png`
> - `spr_tileset.png` — vægfliserne

### Trin 3.3 — Importér sprites til GameMaker
For hvert billede fil:
1. I **Asset Browser**, højreklik på **Sprites** → **Create Sprite**
2. Klik **Import** → find PNG filen → klik Open
3. Omdøb spriten så den passer til filnavnet (f.eks. `the_skeld`, `spr_player_idle_down`)

> **Tip:** Kald dem præcis som vist ovenfor — koden vi skriver senere vil referere til dem efter navn.

Flere sprites tilføjes i senere sessions når vi skal bruge dem.

---

## Del 4 — Rundtur i IDE (15 min)

Når projektet åbner vil du se masser af paneler. Lad os lære hvad de alle gør.

```
┌─────────────────────────────────────────────────────────┐
│  MENU BAR  (File, Edit, Build...)                       │
├──────────────┬──────────────────────────┬───────────────┤
│              │                          │               │
│  ASSET       │   WORKSPACE              │  INSPECTOR    │
│  BROWSER     │   (room editor /         │  (egenskaber  │
│              │    code editor kommer)   │   for valgt   │
│  Alt dine    │                          │   ting)       │
│  sprites,    │                          │               │
│  objects,    │                          │               │
│  rooms...    │                          │               │
└──────────────┴──────────────────────────┴───────────────┘
```

### Vigtige ting at klikke på og udforske:
- **Asset Browser** (venstre panel) — dobbelt-klik `Room1` for at åbne room editoren
- **Room Editor** — det store lærred hvor du lægger alt
- Dobbelt-klik **`spr_player_idle_down`** i Asset Browser → se spilleren sprite du lige importerede!

> **Udfordring:** Dobbelt-klik på `the_skeld` spriten. Hvad ser du? Hvor stor er den i pixels?

---

## Del 5 — Opsætning af Room (20 min)

Nu for det sjovt — bygning af rumskibsniveauet!

### Trin 5.1 — Åbn Room1
I Asset Browser, dobbelt-klik på **Room1**. Room Editoren åbner i arbejdsområdet.

### Trin 5.2 — Indstil rum størrelse
I Inspector på højre siden, find **Room Settings**:
- Sæt **Width** til `1280`
- Sæt **Height** til `720`

### Trin 5.3 — Tilføj rumskibsbaggrund
I Room Editoren, kig på **Layers** panelet. Du vil se en liste over lag (som lag i Photoshop).

1. Klik **+** knappen for at tilføje et **Background layer**
2. Kald det `Background`
3. I Inspector, klik **Sprite** og vælg `the_skeld` (Among Us skib billedet)
4. Sørg for at **Stretch** er slået TIL så det fylder hele rummet

Du burde nu se rumskibet på baggrunden! 🚀

### Trin 5.4 — Check vægflis laget
Lag er som gennemsigtige ark stablet oven på hinanden. Kollisions vægge skal være på deres eget lag.

I Layers panelet, find laget kaldet **`mur`** (Fransk for "væg" — bare ignorer navnet!).

- Hvis det er der: godt, klik på det for at vælge det
- Hvis det mangler: klik **+** → **Tile Layer** → kald det `mur` → sæt tileset til `TileSet1`

### Trin 5.5 — Mal nogle vægge (valgfrit, men cool)
Med `mur` laget valgt:
1. Vælg **Tile Brush** værktøjet (blyant ikon)
2. Vælg en væg flis fra tileset paletten nederst
3. Mal over væggen på rumskibet baggrundsbilledet

Dette fortæller GameMaker "disse steder er solide vægge — spilleren kan ikke gå igennem dem."

> **Tip:** Du behøver ikke være pixel-perfekt. Bare blok for de store vægge.

### Trin 5.6 — Tilføj spilleren til rummet
1. I Layers panelet, vælg **Instances** laget (eller opret et med **+** → **Instance Layer**)
2. I Asset Browser, find **JackVenomTank** (dette er din spiller object)
3. Træk det fra Asset Browser ind i midten af rummet på kortet

Du burde se et lille karakterikon placeret i dit rum!

---

## Del 6 — Tryk Play! (10 min)

Klik på **▶ Play** knappen øverst (eller tryk `F5`).

GameMaker vil kompilere dit projekt og et vindue burde poppe op. Prøv at trykke:
- **W A S D** for at bevæge
- **Space** for at angribe

> Hvis det ikke virker, tjek: Er spiller objektet placeret i rummet? Hedder `mur` laget det rigtige?

---

## Sammenfatning — Hvad du byggede i dag ✅

- [x] Installerede GameMaker og oprettede dit eget projekt fra bunden
- [x] Downloadede sprite billeder fra GitHub og importerede dem
- [x] Udforskede IDE (Asset Browser, Room Editor, Inspector)
- [x] Satte et rumskibsbaggrund i Room1
- [x] Forstod lag (baggrund, væg fliser, instanser)
- [x] Placerede spilleren og kørte spillet

## Lektie / Bonus Udfordring 🌟
- Prøv at ændre **rum størrelse** til `2560 x 1440` og se hvad der sker
- Download `spr_npc1.png` fra GitHub og importér det — hvad ser det ud som?
- Kan du tilføje en **anden kopi** af `JackVenomTank` til rummet? Hvad sker der når du trykker Play?

---

## Kommer i Session 2...
Du vil få spilleren til at bevæge sig OG se i den rigtige retning, tilføje et kamera der følger dig, og tilføje besætningsmedlemmer der vandrer omkring på skibet. Så... lærer du hvordan du **eliminerer dem**. 😈
