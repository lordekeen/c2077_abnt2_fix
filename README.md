# Cyberpunk 2077 ABNT2 Keyboard Fix

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/github/v/release/lordekeen/cyberpunk2077-abnt2-fix)](https://github.com/lordekeen/cyberpunk2077-abnt2-fix/releases)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)]()
[![Game Version](https://img.shields.io/badge/Cyberpunk%202077-Compatible-green.svg)]()

## 🎮 Sobre o Mod

Este mod corrige problemas de teclado ABNT2 no Cyberpunk 2077, permitindo que jogadores brasileiros utilizem adequadamente caracteres especiais e acentos durante o jogo.

### ✨ Funcionalidades

- **Correção de Teclas**: Remapeia a tecla `?/` (vkC1) para funcionar corretamente
- **Suporte a Acentos**: Permite digitação correta de caracteres acentuados (á, é, í, ó, ú, ã, õ, â, ê, ô)
- **Ativação Automática**: O mod é ativado automaticamente quando o Cyberpunk 2077 está rodando
- **Transparente**: Funciona em segundo plano sem interferir na jogabilidade
- **Logging**: Sistema de logs para debug e rastreamento de atividade

## 🔧 Instalação

### Instalação Manual (Recomendado)

1. Baixe a versão mais recente na seção [Releases](https://github.com/lordekeen/cyberpunk2077-abnt2-fix/releases)
2. Extraia os arquivos para a pasta `Cyberpunk 2077\red4ext\plugins\ABNT2_Fix\`
3. O mod será carregado automaticamente quando o jogo iniciar

### Usando Gerenciador de Mods (Vortex)

1. Baixe o arquivo do mod
2. Instale através do Vortex Mod Manager
3. Ative o mod na lista de mods do Vortex
4. O mod será instalado automaticamente na pasta correta

### Estrutura de Pastas
```
Cyberpunk 2077\
└── red4ext\
    └── plugins\
        └── ABNT2_Fix\
            ├── ABNT2_Fix.dll
            └── cyberpunk2077_abnt2_fix.exe
```

## 🎯 Como Usar

1. Instale o mod conforme as instruções acima
2. Inicie o Cyberpunk 2077
3. O mod será ativado automaticamente
4. Use seu teclado ABNT2 normalmente!

### Mapeamento de Teclas

- **Tecla `?/`**: Agora funciona corretamente
  - Sem Shift: `/`
  - Com Shift: `?`
- **Acentos**: Funcionam como esperado
  - `´` + vogal = vogal com acento agudo (á, é, í, ó, ú)
  - `~` + vogal = vogal com til (ã, õ)
  - `^` + vogal = vogal com circunflexo (â, ê, ô)

## 🛠️ Compilação do Código Fonte

### Pré-requisitos

- Visual Studio 2019/2022 ou equivalente
- CMake 3.15+
- [RED4ext SDK](https://github.com/WopsS/RED4ext.SDK)
- AutoHotkey v2.0
- [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe) - Para compilar o script .ahk em executável .exe

### Compilando a DLL

```bash
cd source/dll
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

### Compilando o Script AutoHotkey

1. Instale o [AutoHotkey v2.0](https://www.autohotkey.com/download/)
2. Baixe o [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe) (compilador standalone)
3. Compile o script usando o comando:
   ```
   Ahk2Exe.exe /in "source/ahk/cyberpunk2077_abnt2_fix.ahk" /out "cyberpunk2077_abnt2_fix.exe"
   ```

## 🔒 Segurança

Este projeto é **100% open source** para garantir transparência e confiança da comunidade:

- **Código Fonte Disponível**: Todo o código está disponível neste repositório
- **Sem Malware**: O código pode ser auditado por qualquer pessoa
- **Builds Reproduzíveis**: Você pode compilar o mod a partir do código fonte
- **Assinatura Digital**: Releases oficiais são assinadas (quando aplicável)

### Verificação de Integridade

Todos os arquivos de release incluem checksums SHA256 para verificação de integridade.

## 📋 Compatibilidade

- **Sistema Operacional**: Windows 10/11
- **Cyberpunk 2077**: Todas as versões compatíveis com RED4ext
- **Teclado**: ABNT2 (Layout Brasileiro)
- **Gerenciadores de Mod**: Vortex, instalação manual

## 🐛 Relatório de Bugs

Encontrou um problema? Por favor, [abra uma issue](https://github.com/lordekeen/cyberpunk2077-abnt2-fix/issues) com:

1. Versão do mod
2. Versão do Cyberpunk 2077
3. Descrição detalhada do problema
4. Logs (se disponíveis)

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE) - veja o arquivo LICENSE para detalhes.

## 🙏 Agradecimentos

- [AutoHotkey Community](https://www.autohotkey.com/)
- [RED4ext](https://github.com/WopsS/RED4ext.SDK) por fornecer o framework de modding
- Comunidade de Cyberpunk 2077