# Anderhaus Construction — Deploy y SEO

## Cloudflare Pages

1. https://dash.cloudflare.com → Workers & Pages → **Create application** → Connect to Git
2. Repo: **yariancn/anderhausconstruction** (crear en GitHub primero), branch **main**
3. Build command: *(vacío)* | Output directory: **/**
4. Custom domains: `anderhausconstruction.com` y `www.anderhausconstruction.com`

---

## Migración desde Canva

El sitio actual (`anderhausconstruction.com`) está alojado en **Canva Websites**, igual que OXYGENGDL antes de la migración.

| Paso | Acción |
|------|--------|
| 1 | Subir este repo a GitHub y conectar Cloudflare Pages |
| 2 | Verificar preview en `*.pages.dev` |
| 3 | En Cloudflare DNS del dominio, apuntar `anderhausconstruction.com` a Pages (CNAME o registro automático) |
| 4 | Desconectar dominio en Canva (o dejar de renovar el plan de sitio web) |
| 5 | Configurar redirect `www` → raíz en Cloudflare Pages |

---

## Google Search Console

1. https://search.google.com/search-console → **Agregar propiedad** → `https://anderhausconstruction.com`
2. Verificar por **registro DNS TXT** en Cloudflare (mismo método que OXYGENGDL)
3. Enviar sitemap: `sitemap.xml`
4. Inspección de URLs → solicitar indexación de `https://anderhausconstruction.com/`

---

## Google Business Profile

Si existe ficha de negocio, actualizar:

- **Sitio web** → `https://anderhausconstruction.com`
- **Dirección** → 256 Ed English Dr, Bldg 4 Ste E, Shenandoah, TX 77385
- **Teléfono** → (713) 591-3379

---

## Checklist técnico del sitio

- [x] HTML estático optimizado (sin Canva JS)
- [x] Canonical `https://anderhausconstruction.com/`
- [x] `robots.txt` + `sitemap.xml`
- [x] Schema.org (HomeAndConstructionBusiness, FAQ)
- [x] Open Graph + geo tags
- [x] `llms.txt`
- [x] `_headers` de seguridad y caché
- [x] Video hero + imágenes en `/assets/`
- [ ] Repo en GitHub + Cloudflare Pages ← **pendiente**
- [ ] DNS apuntando a Pages ← **pendiente**
- [ ] Search Console verificado ← **pendiente**
- [ ] Dominio desconectado de Canva ← **pendiente**

---

## Tiempo estimado

| Fase | Tiempo |
|------|--------|
| Deploy en Pages + DNS | Mismo día |
| Primera indexación | 3–14 días |
| Consolidación en resultados | 2–6 semanas |
