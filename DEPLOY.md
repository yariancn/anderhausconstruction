# Anderhaus Construction — Dominio propio (Namecheap → Cloudflare Workers)

## Estado actual

| URL | Qué muestra |
|-----|-------------|
| `https://anderhausconstruction.yarianc.workers.dev` | **Sitio nuevo** (correcto) |
| `https://anderhausconstruction.com` | **Sitio viejo de Canva** |

El dominio está registrado en **Namecheap** con nameservers de Namecheap (`dns1/2.registrar-servers.com`). Canva responde con IP `103.169.142.0` vía Cloudflare de ellos.

Para usar el sitio nuevo en tu dominio propio, hay que **mover el DNS a Cloudflare** y conectar el dominio al Worker. No basta con cambiar un registro en Namecheap sin pasar por Cloudflare si el sitio vive en Workers.

---

## Paso 1 — Crear cuenta / zona en Cloudflare (gratis)

1. Entra a [https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up) (o inicia sesión).
2. **Add a site** → escribe `anderhausconstruction.com` → plan **Free**.
3. Cloudflare escaneará los DNS actuales. **No importa** si aparecen registros de Canva.
4. Cloudflare te dará **2 nameservers**, por ejemplo:
   - `ada.ns.cloudflare.com`
   - `bob.ns.cloudflare.com`  
   (los tuyos serán distintos; copia los que te muestre el panel)

---

## Paso 2 — Cambiar nameservers en Namecheap

1. [https://ap.www.namecheap.com/domains/list/](https://ap.www.namecheap.com/domains/list/)
2. **Manage** junto a `anderhausconstruction.com`
3. Sección **Nameservers** → **Custom DNS**
4. Pega los **2 nameservers de Cloudflare** (borra los de Namecheap).
5. Guarda.

La propagación suele tardar **15 minutos a 24 horas**. Cloudflare te enviará un email cuando el dominio esté **Active**.

> **Nota:** El dominio sigue comprado en Namecheap; solo delegas el DNS a Cloudflare. La renovación anual sigue en Namecheap.

---

## Paso 3 — Conectar el dominio al Worker

Cuando Cloudflare muestre el dominio como **Active**:

1. [https://dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages**
2. Abre el worker **`anderhausconstruction`**
3. **Settings** → **Domains & Routes** → **Add**
4. Agrega:
   - `anderhausconstruction.com`
   - `www.anderhausconstruction.com`
5. Cloudflare crea/ajusta los registros DNS automáticamente (proxy naranja ☁️).

El sitio nuevo debería verse en unos minutos en el dominio propio.

---

## Paso 4 — Limpiar DNS de Canva (en Cloudflare)

En **DNS** → **Records** del dominio, **elimina** registros que apunten a Canva, por ejemplo:

- A o CNAME hacia IPs/servicios de Canva
- CNAME tipo `www` → dominio de Canva

Deja los que Cloudflare creó para el Worker. Si hay duda, no borres registros que digan Workers o que Cloudflare acaba de añadir.

---

## Paso 5 — Desconectar Canva

1. Inicia sesión en [Canva](https://www.canva.com)
2. Abre el sitio web publicado de Anderhaus
3. **Settings** / **Domain** / **Manage domain**
4. **Disconnect** o quita `anderhausconstruction.com`

Así Canva deja de reclamar el dominio y evitas conflictos.

---

## Paso 6 — Verificar que funciona

En terminal (o abre el sitio en el navegador en ventana privada):

```bash
curl -s https://anderhausconstruction.com | head -5
```

**Correcto:** HTML con `Anderhaus Construction`, `Building a Home for You`, etc.

**Incorrecto:** HTML con `__canva_website_bootstrap__` o `export_website`.

También prueba:

- `https://www.anderhausconstruction.com`
- `https://anderhausconstruction.com/assets/images/favicon.png` (debe cargar, no 404)
- En móvil: botón flotante de mensaje y enlace **Text Us**

---

## Paso 7 — SEO después del cambio de dominio

### Google Search Console

1. [https://search.google.com/search-console](https://search.google.com/search-console)
2. **Add property** → `https://anderhausconstruction.com`
3. Verificación recomendada: registro **TXT** en DNS (Cloudflare → DNS → Add record)
4. **Sitemaps** → enviar: `https://anderhausconstruction.com/sitemap.xml`
5. **URL Inspection** → pedir indexación de la home

### Google Business Profile

Actualiza el sitio web del perfil de negocio a `https://anderhausconstruction.com` si aún apunta a Canva.

### Bing Webmaster Tools (opcional)

[https://www.bing.com/webmasters](https://www.bing.com/webmasters) — mismo sitemap.

---

## Redirect www → raíz (opcional)

Si quieres que `www` redirija a sin `www`, en Cloudflare:

**Rules** → **Redirect Rules** → Create rule:

- If hostname equals `www.anderhausconstruction.com`
- Then **Dynamic** redirect to `https://anderhausconstruction.com${uri.path}`

O añade en `_redirects` del repo (si el Worker lo soporta en tu deploy).

---

## Resumen rápido

```
Namecheap (registro)  →  nameservers apuntan a Cloudflare
Cloudflare DNS        →  dominio conectado al Worker anderhausconstruction
Canva                 →  dominio desconectado
Search Console        →  sitemap + reindexación
```

---

## Sitio y deploy

- Preview Worker: `https://anderhausconstruction.yarianc.workers.dev`
- Repo: `github.com/yariancn/anderhausconstruction`
- Deploy: automático al hacer `git push` a `main`

---

## Checklist

- [x] Sitio estático en GitHub + Workers
- [x] SEO, favicon, carrusel, SMS, llms.txt
- [ ] Nameservers en Namecheap → Cloudflare
- [ ] Dominio Active en Cloudflare
- [ ] `anderhausconstruction.com` + `www` en el Worker
- [ ] Registros DNS de Canva eliminados
- [ ] Canva desconectado del dominio
- [ ] Verificación con `curl` o navegador
- [ ] Google Search Console + sitemap
- [ ] Google Business Profile actualizado
