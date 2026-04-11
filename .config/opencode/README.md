# OpenCode Global Configuration

Esta carpeta contiene toda la configuración global de OpenCode.

## Archivos Principales

### `opencode.json`
Configuración principal de OpenCode incluyendo:
- Modelo principal (Claude Sonnet 4.5)
- Modelo pequeño (Claude Haiku 4.5)
- Providers (Ollama local)
- MCP Servers (GitHub, NotebookLM, Context7, Sentry, Grep)
- Configuración de herramientas y permisos

### `tui.json`
Configuración específica de la interfaz terminal (TUI):
- Tema (Tokyo Night)
- Comportamiento del scroll
- Soporte de ratón

## Documentación MCP

### `MCP_SETUP_GUIDE.md`
Guía completa y detallada sobre cómo:
- Configurar GitHub MCP
- Configurar NotebookLM MCP
- Usar otros MCP servers
- Troubleshooting
- Mejores prácticas

### `QUICK_START_MCP.txt`
Guía rápida con formato visual para:
- Setup rápido de GitHub
- Setup rápido de NotebookLM
- Comandos útiles
- Verificación de configuración

### `opencode-github-enabled.json.example`
Ejemplo de configuración con GitHub MCP habilitado.
Útil para ver cómo debe verse la config cuando habilitas un MCP.

## Estructura de Configuración

```
~/.config/opencode/
├── opencode.json              # Config principal
├── tui.json                   # Config TUI
├── README.md                  # Este archivo
├── MCP_SETUP_GUIDE.md        # Guía MCP detallada
├── QUICK_START_MCP.txt       # Guía MCP rápida
├── opencode-github-enabled.json.example  # Ejemplo
├── agent/                     # Custom agents
├── commands/                  # Custom commands
├── plugins/                   # Custom plugins
├── tools/                     # Custom tools
└── themes/                    # Custom themes
```

## Configuración Actual

### Providers
- **Ollama** (Local) - Llama 2, Mistral, Neural Chat

### MCP Servers (Deshabilitados por defecto)
- GitHub MCP
- NotebookLM
- Context7
- Sentry
- Grep by Vercel

## Próximos Pasos

1. **Habilitar GitHub MCP**:
   - Crear token en https://github.com/settings/tokens
   - Configurar `GITHUB_TOKEN` como variable de entorno
   - Editar `opencode.json` y cambiar `github.enabled` a `true`

2. **Habilitar NotebookLM MCP**:
   - Crear API key en https://notebooklm.google.com
   - Configurar `NOTEBOOKLM_API_KEY` como variable de entorno
   - Editar `opencode.json` y cambiar `notebooklm.enabled` a `true`

3. **Usar en OpenCode**:
   ```bash
   export GITHUB_TOKEN=ghp_xxxxx
   export NOTEBOOKLM_API_KEY=xxxxx
   opencode
   ```

## Comandos Útiles

```bash
# Ver estado de MCP servers
opencode mcp list

# Debug de conexión MCP
opencode mcp debug github

# Autenticar OAuth
opencode mcp auth sentry

# Logout
opencode mcp logout sentry

# Ver config actual
cat ~/.config/opencode/opencode.json | jq .
```

## Tips Importantes

✓ Los MCP servers consumen contexto - habilita solo los que necesites
✓ Usa variables de entorno para credenciales sensibles
✓ Lee `MCP_SETUP_GUIDE.md` para troubleshooting detallado
✓ Mantén los archivos de configuración seguros

## Recursos

- [OpenCode Docs](https://opencode.ai/docs/)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [GitHub API](https://docs.github.com/en/rest)
- [NotebookLM](https://notebooklm.google.com/)

---

**Última actualización**: Abril 11, 2026
