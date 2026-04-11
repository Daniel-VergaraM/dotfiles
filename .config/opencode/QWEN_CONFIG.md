# Qwen 2.5 Coder 7B en OpenCode

## Estado Actual

Tu OpenCode tiene **Qwen 2.5 Coder 7B** configurado como modelo disponible en el provider Ollama.

**Modelo Principal (por defecto):** Claude Sonnet 4.5 (Anthropic)
**Modelo disponible en Ollama:** qwen2.5-coder:7b

```json
"provider": {
  "ollama": {
    "models": {
      "qwen2.5-coder:7b": {
        "name": "Qwen 2.5 Coder 7B"
      }
    }
  }
}
```

## Cómo Cambiar a Qwen

### Opción 1: En OpenCode (Temporal)

1. Inicia OpenCode:
   ```bash
   opencode
   ```

2. En el chat, ejecuta:
   ```
   /models
   ```

3. Selecciona: **Qwen 2.5 Coder 7B**

### Opción 2: Por Línea de Comandos (Temporal)

```bash
opencode --model ollama/qwen2.5-coder:7b
```

### Opción 3: Hacer Permanente

Edita `~/.config/opencode/opencode.json`:

```json
"model": "ollama/qwen2.5-coder:7b",
"small_model": "ollama/qwen2.5-coder:7b"
```

Luego reinicia OpenCode.

---

## Especificaciones de Qwen 2.5 Coder 7B

**Desarrollador:** Alibaba Qwen Team
**Parámetros:** 7 Billones
**Especialización:** Programación y coding
**Tamaño:** ~7B parámetros
**Contexto:** ~128K tokens (típicamente)
**Velocidad:** ⭐⭐⭐⭐ Rápido
**Calidad:** ⭐⭐⭐⭐ Excelente

## Ventajas

✓ **Optimizado para código** - Completaciones, análisis, refactoring
✓ **Rápido** - 7B es más rápido que modelos más grandes
✓ **Bajo consumo** - Funciona bien en máquinas locales
✓ **Especializado** - Entrenado específicamente en programación
✓ **Contexto amplio** - Puede manejar archivos grandes

## Requisitos

### Descargar el modelo

```bash
ollama pull qwen2.5-coder:7b
```

### Verificar disponibilidad

```bash
ollama list | grep qwen2.5-coder
```

### Asegurar que Ollama está corriendo

```bash
ollama serve
```

---

## Ejemplos de Uso

### Cambiar a Qwen en OpenCode

```bash
opencode
```

En el chat:
```
/models
→ Selecciona "Qwen 2.5 Coder 7B"

Ahora puedes usar Qwen para:
> Analiza este código y sugiere mejoras
> Completa esta función Python
> ¿Por qué falla este código?
```

### Usar desde CLI

```bash
opencode --model ollama/qwen2.5-coder:7b run "Explica este código: [tu código]"
```

---

## Comparativa de Modelos

| Modelo | Tamaño | Especialización | Velocidad | Calidad | Uso Recomendado |
|--------|--------|-----------------|-----------|---------|-----------------|
| Claude Sonnet 4.5 | Grande | General | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Por defecto (mejor calidad) |
| Qwen 2.5 Coder 7B | 7B | Código | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Programación local |
| Llama 2 | 7B/13B | General | ⭐⭐⭐⭐ | ⭐⭐⭐ | Uso general local |
| Mistral | 7B | General | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Velocidad máxima |

---

## Troubleshooting

### Modelo no aparece en /models

1. Verifica que está descargado:
   ```bash
   ollama list
   ```

2. Verifica que Ollama está corriendo:
   ```bash
   curl http://localhost:11434/v1/models
   ```

3. Descárgalo si no existe:
   ```bash
   ollama pull qwen2.5-coder:7b
   ```

### Lentitud al usar Qwen

1. Qwen 7B es rápido pero consume recursos. Si está lento:
   - Cierra otras aplicaciones
   - Aumenta RAM disponible

2. Si sigue lento, aumenta timeout:
   ```json
   "provider": {
     "ollama": {
       "options": {
         "timeout": 120000
       }
     }
   }
   ```

### Error de conexión a Ollama

```bash
# Verifica que Ollama está corriendo
ollama serve

# Verifica la conexión
curl http://localhost:11434/v1/models
```

---

## Comandos Útiles

```bash
# Ver modelo actual
cat ~/.config/opencode/opencode.json | jq '.model'

# Cambiar modelo en CLI
opencode --model ollama/qwen2.5-coder:7b

# Ver modelos disponibles
ollama list

# Información del modelo
ollama show qwen2.5-coder:7b

# Probar conexión a Ollama
curl http://localhost:11434/v1/models

# Ejecutar OpenCode con Qwen
opencode --model ollama/qwen2.5-coder:7b
```

---

## Casos de Uso Ideales para Qwen

✓ **Análisis de código local** - Sin enviar datos a servidores externos
✓ **Completaciones de código** - Rápidas y eficientes
✓ **Refactoring** - Sugiere mejoras en código
✓ **Bug fixing** - Ayuda a identificar y solucionar errores
✓ **Explicaciones técnicas** - Especializado en conceptos de programación
✓ **Documentación** - Genera comentarios y documentación

---

## Recursos

- [Qwen Official](https://github.com/QwenLM/Qwen)
- [Ollama Docs](https://ollama.ai)
- [Modelo en Ollama Hub](https://ollama.ai/library/qwen2.5-coder)
- [OpenCode Docs](https://opencode.ai/docs/)

---

**Última actualización:** Abril 11, 2026
**Modelo:** Qwen 2.5 Coder 7B (disponible en Ollama)
**Modelo principal:** Claude Sonnet 4.5
**Status:** ✅ Configurado y listo

