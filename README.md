# Aula Cubit

Este projeto é um aplicativo simples desenvolvido para demonstrar o uso do `Cubit` como gerenciador de estados em um aplicativo Flutter.

## Visão Geral

O objetivo principal deste projeto é fornecer um exemplo claro e conciso de como utilizar o `Cubit` para gerenciar o estado de um aplicativo. O `Cubit` é uma solução de gerenciamento de estado leve e previsível, que faz parte do pacote `bloc`.

## Funcionalidades

O aplicativo consiste em uma lista de tarefas (to-do list) onde é possível:

*   Adicionar novas tarefas
*   Marcar tarefas como concluídas
*   Remover tarefas da lista

## Estrutura do Projeto

O projeto está estruturado da seguinte forma:

*   `lib/cubits`: Contém os `Cubits` responsáveis por gerenciar o estado da aplicação.
    *   `todo_cubit.dart`: Gerencia o estado da lista de tarefas.
    *   `todo_state.dart`: Define os diferentes estados da lista de tarefas.
*   `lib/view`: Contém a interface do usuário do aplicativo.
    *   `pages/home_page.dart`: A tela principal do aplicativo.
    *   `widgets/todo_list_widget.dart`: O widget que exibe a lista de tarefas.
*   `lib/main.dart`: O ponto de entrada do aplicativo.

## Como Executar o Projeto

1.  Certifique-se de ter o Flutter instalado em sua máquina.
2.  Clone este repositório.
3.  Execute `flutter pub get` para instalar as dependências.
4.  Execute `flutter run` para iniciar o aplicativo.

## Aprendizados

Ao explorar este projeto, você aprenderá:

*   Como criar e utilizar um `Cubit`.
*   Como emitir e ouvir as mudanças de estado.
*   Como conectar a interface do usuário ao `Cubit` para refletir as mudanças de estado.
*   Uma abordagem estruturada para organizar seu código ao usar o `Cubit`.