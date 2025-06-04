# Caça aos Ovos de Páscoa - iOS App

## Introdução

Aplicativo iOS desenvolvido em Swift utilizando arquitetura MVVM, que implementa uma caça aos ovos de Páscoa através de realidade aumentada (ARKit). O projeto tem integração entre SwiftUI, SwiftData para persistência local, networking assíncrono com URLSession, e gerenciamento de estados complexos em ViewModels.

A aplicação utiliza padrões modernos de desenvolvimento iOS, incluindo async/await para operações assíncronas e Swift Package Manager para modularização da camada de network.

## Arquitetura

O projeto segue a arquitetura MVVM (Model-View-ViewModel) com separação clara de responsabilidades:

- **Models**: Entidades SwiftData (Clue, GameProgress, MoviesEntity) para persistência local
- **ViewModels**: Gerenciamento de estado e lógica de negócio (ex GameViewModel)
- **Views**: Interface SwiftUI com binding reativo aos ViewModels
- **Network Layer**: Módulo separado via SPM para comunicação com APIs externas

## Tecnologias Utilizadas

- SwiftUI
- ARKit para realidade aumentada
- SwiftData para persistência de dados
- URLSession com async/await para networking
- Swift Package Manager para modularização
- SwiftTesting para testes unitários
- TMDB API para catálogo de filmes

## Configuração e Instalação

### Pré-requisitos
- Xcode 15.0+
- iOS 17.0+
- Dispositivo físico com suporte a ARKit (recomendado)

### Instalação

1. Clone o repositório
2. **IMPORTANTE**: O projeto utiliza Swift Package Manager para o módulo MoviesNetwork. Aguarde o Xcode resolver as dependências automaticamente ou configure manualmente em File -> Add Package Dependencies
3. Configure a API key do TMDB em TMDBEndpointFactory.swift
4. Build e execute o projeto

### Como testar

Para acessar a funcionalidade de filmes sem completar a caça aos ovos:
- Em dispositivo físico: Complete os 4 desafios AR
- No simulador: Use o botão "Simular Encontrar Pista" disponível durante o desenvolvimento

## Funcionalidades Implementadas

- Sistema de caça aos ovos com 4 pistas em AR
- Progressão sequencial com desbloqueio de pistas
- Persistência de progresso do jogo
- Catálogo de filmes temáticos integrado com TMDB API
- Interface responsiva e estados de loading/error

## Testes

O projeto inclui testes unitários para a camada de ViewModel, cobrindo:
- Inicialização do jogo
- Lógica de encontrar pistas
- Gerenciamento de estado
- Persistência de dados

Execute os testes com Cmd+U no Xcode.

## Limitações e Melhorias Futuras

### Não implementado por limitação de tempo:

1. **Aplicativo para configuração**: Interface administrativa para pais definirem locais das pistas
2. **Mapeamento real**: Sincronização entre coordenadas GPS e coordenadas ARKit
3. **Segurança**: Gerenciamento de API keys via Keychain
4. **Cache otimizado**: Sistema de cache para vídeos e imagens

### Melhorias com mais tempo de desenvolvimento:

- Expansão da cobertura de testes (incluindo UI tests)
- Integração com anúncios contextuais de estabelecimentos locais
- Funcionalidade de pegadas do coelho em AR para o desafio final
- Sistema de streaming otimizado para trailers
- Backend para sincronização entre dispositivos
- Analytics de engajamento e completion rate

## Considerações Técnicas

O projeto prioriza demonstração de competências em:
- Desenvolvimento iOS moderno com Swift 6
- Arquitetura escalável e testável
- Integração de múltiplas tecnologias (AR, persistência, networking)
- Qualidade de código e boas práticas
- Gerenciamento de dependências e modularização

## Estrutura de Dados

- **Clue**: Entidade SwiftData representando pistas do jogo
- **GameProgress**: Controle de progresso e estado do jogo
- **GameViewModel**: Coordenação entre UI e lógica de negócio
- **MoviesNetwork**: Módulo SPM para comunicação com TMDB API
