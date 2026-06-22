# Anderhaus Construction — Deploy y DNS

## Sitio nuevo (Cloudflare Workers)

- Preview: `https://anderhausconstruction.yarianc.workers.dev`
- Repo: `github.com/yariancn/anderhausconstruction`

---

## IMPORTANTE: conectar el dominio (paso pendiente)

Hoy `anderhausconstruction.com` **sigue mostrando el sitio viejo de Canva**. Por eso no ves el favicon nuevo ni el banner de Our Services.

### Pasos en Cloudflare Dashboard

1. https://dash.cloudflare.com → dominio **anderhausconstruction.com**
2. **Workers & Pages** → worker **anderhausconstruction**
3. **Settings** → **Domains & Routes** → **Add** → `anderhausconstruction.com`
4. Repetir para `www.anderhausconstruction.com` (redirect a raíz si lo ofrece)
5. **DNS** → revisar que no quede un registro apuntando a Canva:
   - Eliminar CNAME/A de Canva si existe
   - El dominio custom del Worker crea los registros necesarios
6. En **Canva** → desconectar `anderhausconstruction.com` del sitio publicado

### Cómo verificar que ya funciona

```bash
curl -sI https://anderhausconstruction.com | head -5
```

Debe responder el sitio estático (no HTML de Canva con `__canva_website_bootstrap__`).

---

## Google Search Console

1. https://search.google.com/search-console → propiedad `https://anderhausconstruction.com`
2. Verificar por DNS TXT en Cloudflare
3. Enviar sitemap: `sitemap.xml`
4. Solicitar indexación de la página principal

---

## Checklist

- [x] Sitio estático en GitHub + Workers
- [x] Favicon, Our Services banner, SEO, llms.txt
- [ ] Dominio `anderhausconstruction.com` → Worker (no Canva) ← **hacer ahora**
- [ ] Canva desconectado del dominio
- [ ] Search Console + sitemap
