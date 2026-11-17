import 'package:good_manager/presentation/markdown/md_bundle.dart';

class MarkdownResourcePT {
  static const bundle = MarkdownBundle(
    whatNews: """
### Versão 1.0.94 - 17 nov 2026
* A versão para Windows já está disponível. Use o novo banner da tela inicial para baixá-la.
* Agora você pode copiar um produto ou um grupo: pressione e segure, escolha Copiar e selecione a loja e o grupo.
* Desbloqueie com a digital (Face ID no iPhone) quando o bloqueio por senha estiver ativado.
* O app bloqueia automaticamente após um período de inatividade (30 minutos por padrão, ajustável em Configurações).
* Nova configuração de tamanho da imagem e opção para ocultar a janela de recorte ao adicionar imagens.
* Nova configuração de atraso entre leituras na leitura em lote.
* Redefinir a numeração de documentos agora pede confirmação.
* Corrigidos fechamentos inesperados offline, quando a foto de perfil não carrega ou ao digitar um preço ou valor inválido.
* Corrigidos fechamentos nas listas de Documentos, Pagamentos e Histórico após excluir ou filtrar itens, e quando a permissão de câmera ou de notificações é negada.

### Versão 1.0.93 - 30 out 2026
* Novos avisos modernos que deslizam do topo. Deslize para cima ou toque para fechar.
* Todas as mensagens agora usam o mesmo estilo, com cores para sucesso, alerta e erro.
* O app agora se chama Stock & Inventory Manager.
* Espaçamento e tamanhos mais consistentes em cartões e listas em todas as telas.
* Menu de toque longo nos itens mais limpo.
* Corrigido o botão Avaliar o app nas Configurações para abrir a página da loja.

### Versão 1.0.92 - 12 out 2026
* Totais de entrada e saída no cartão de documentos da página inicial.
* Barra de resumo em Itens, Histórico, Documentos, Pagamentos, Lojas, Fornecedores e Clientes.
* O resumo de documentos e pagamentos segue a aba selecionada.
* Fornecedor usa ícone de caminhão. Cliente usa ícone de usuários.
* Ajuda e notas da versão em todos os idiomas do app.

### Versão 1.0.91 - 08 out 2026
* Importação e exportação de Excel no menu de estoque.
* Ações de toque longo nos documentos recentes da página inicial.
* Ações de toque longo nos resultados da busca.
* Categorias passou a se chamar Categorias de pagamento em Configurações.

### Versão 1.0.90 - 06 out 2026
* Atualização da página inicial, estoque, pagamentos, relatórios e configurações.
* Fotos para lojas, grupos, clientes e fornecedores.
* Atualização de listas, estados vazios e introdução.
* Traduções aprimoradas.
* Correção de erros relatados.

### Versão 1.0.80 - 23 abr 2026
* Correção de erros relatados.
* Guia para migrar para a versão online.
* Interface renovada.

### Versão 1.0.75 - 16 abr 2026
* Correção de erros relatados.
* Nova moeda.
* Correção de códigos de barras duplicados.

### Versão 1.0.70 - 06 fev 2026
* Correção de erros relatados.
* Nova moeda.
* Atualização da sincronização.
* Atualização do logotipo (versão online).

### Versão 1.0.65 - 20 set 2025
* Correção de erros relatados.
* Novo relatório: informações do item.

### Versão 1.0.60 - 09 set 2025
* Correção do login com conta Apple.
* Correção de erros relatados.
* Configurações de tema, idioma e moeda.
* Atualização do logotipo e dos arquivos ao salvar um item.
* Atualização da autenticação.
* Atualização da interface.

### Versão 1.0.45 - 12 jul 2025
* Correção de erros relatados.

### Versão 1.0.40 - 25 jul 2025
* Correção da leitura de código de barras no Android.
* Correção do alerta de estoque baixo na abertura.
* Correção de erros relatados.
* Idioma do app no menu.
* Atualização da interface.

### Versão 1.0.30 - 30 mai 2025
* Correção de erros relatados.
* Quantidade mínima.
* Informações da empresa.
* Modo escuro e bloqueio por senha.
* Relatório de reposição.

### Versão 1.0.25 - 14 abr 2025
* Correção de erros relatados.
* Pagamentos.
* Carteiras.
* 5 tipos de relatório.

### Versão 1.0.8 - 06 dez 2024
* Correção de erros relatados.
* Configurações de lista em Itens.
* Busca atualizada em Itens.
* Sincronização rápida.

### Versão 1.0.7 - 27 set 2024
* Correção de erros relatados.
* Suporte ao iOS.

### Versão 1.0.6 - 07 jul 2024
* Correção de erros relatados.
* Criação rápida de documento ao salvar um item.
* Histórico do item.

### Versão 1.0.5 - 14 jun 2024
* Login e cadastro.
* Os dados do usuário são salvos na nuvem.
* Correção de erros relatados.

### Versão 1.0.4 - 18 abr 2024
* Correção da rolagem no detalhe do relatório.

### Versão 1.0.3 - 15 abr 2024
* Intervalo de datas nos relatórios.
* Correção de Selecionar grupo.

### Versão 1.0.2 - 12 abr 2024
* Suporte ao Windows.
* Relatório de lista de itens.
* Exportação em PDF e CSV.
* Backup e restauração.

### Versão 1.0.1 - 04 abr 2024
* A quantidade do documento passou de inteiro para decimal.
* Som e vibração ao ler um código de barras.
* Atualização para o Material 3.

### Versão 1.0.0
* Primeira versão.
""",
    helpDocuments: """
## Documentos

Os documentos registram a entrada e a saída de estoque de uma loja.

### Entrada
- Crie um documento de entrada quando as mercadorias **chegam** à loja.
- As quantidades do documento são **somadas** ao estoque.

### Saída
- Crie um documento de saída quando as mercadorias **saem** da loja (por exemplo, uma venda).
- As quantidades do documento são **subtraídas** do estoque.

### Adicionar itens
- Escolha itens do catálogo ou
- **Leia um código de barras** com a câmera.

### Leitura em lote
- Leia os códigos um após o outro. Cada leitura **adiciona o item e aumenta a quantidade em 1**.
- Ou informe a quantidade **manualmente** após cada leitura.
- Escolha o modo em **Configurações**.

### Criação automática
- Um **item novo** adicionado a um documento de entrada (com dados completos) é **salvo no catálogo**.
- Não é possível adicionar um item novo a um documento de saída. O item já precisa existir no estoque.

### Excluir
- **Mantenha pressionado** um documento ou uma linha para excluí-lo.

> Excluir um documento altera o estoque. Só é possível excluir o documento **mais recente**. Excluir um mais antigo pode deixar as quantidades incorretas.

### Filtrar e ordenar
- Use a barra de ferramentas para **filtrar** ou **ordenar** os documentos.
""",
    helpGoods: """
## Itens

A tela Itens é o catálogo de tudo que há na loja, inclusive o estoque atual.

Adicione itens a um documento a partir desta lista. Se o item tiver código de barras, leia-o com a câmera para adicioná-lo rápido.

> A quantidade em estoque não é editada manualmente. Ela é calculada a partir dos documentos.

### Ações
- Ao editar um item, toque na **câmera** ao lado do código para ler.
- **Mantenha pressionado** um item para excluí-lo.
- Use a barra de ferramentas para **buscar** ou **ordenar**.

### Criação automática
- Não é preciso preencher o catálogo antes.
- Crie um documento de entrada e informe um item novo. Ele é **salvo no catálogo** automaticamente.
- Na próxima vez, você pode adicioná-lo lendo o código de barras.
""",
    helpStores: """
## Lojas

Use lojas para separar o estoque por local (loja, depósito e assim por diante).

### Estoque por loja
- Cada loja tem o **próprio estoque**.
- Cada documento pertence a **uma loja**.

### Trocar de loja
- Na **página inicial**, toque no nome ou no avatar da loja para mudar a loja atual.

### Adicionar e gerenciar
- Abra **Lojas** em Configurações para adicionar, editar ou excluir uma loja.

### Limites
- A versão gratuita aceita até **2 lojas**.
- Assine o **Stock Premium** para ter mais. A assinatura inclui **7 dias de teste**.
""",
    helpSupplierCustomers: """
## Fornecedores e clientes

Guarde os dados de fornecedores e clientes em um só lugar. Adicione-os manualmente ou **importe dos contatos**.

### Vincular a um documento
- Em um documento de **entrada**, toque em **Fornecedor**.
- Em um documento de **saída**, toque em **Cliente**.

### Gerenciar registros
- **Mantenha pressionado** um fornecedor ou cliente para:
  - Ver os documentos relacionados
  - Excluir o registro
""",
    helpPayments: """
## Pagamentos

Os pagamentos registram o dinheiro que entra e sai de uma carteira.

### Entrada
- Registre quando você **recebe dinheiro** de um cliente.
- Em geral, vinculado a um documento de **saída**.
- Acompanha o dinheiro que entra.

### Saída
- Registre quando você **paga** um fornecedor.
- Em geral, vinculado a um documento de **entrada**.
- Acompanha o dinheiro que sai.

### Adicionar um pagamento
- Abra **Pagamentos** ou adicione um pagamento a partir de um documento.
- Escolha **Entrada** ou **Saída**.
- Informe **valor**, **data**, pessoa e observações opcionais.
- Vincule um **documento** quando necessário.

### Documentos vinculados
- Um pagamento vinculado mostra para que serve o dinheiro.
- Um pagamento parcial marca o documento como **Parcial**.
- Um pagamento integral marca o documento como **Pago**.

### Editar ou excluir
- **Mantenha pressionado** um pagamento para editá-lo ou excluí-lo.

> Excluir um pagamento pode mudar o status de pagamento do documento.

### Filtrar e ordenar
- Use a barra de ferramentas para **filtrar** ou **ordenar** os pagamentos.
""",
    helpMinQuan: """
## Quantidade mínima

Defina uma **quantidade mínima** em cada item para saber quando repor.

### O que é
- O menor estoque que você quer manter.
- Quando o estoque fica abaixo desse número, o item aparece no relatório **Reposição** e na **página inicial** como estoque baixo.

### Como definir
- Abra um item ao adicionar ou editar.
- Digite um número em **Qtd. mínima** (por exemplo, 5 ou 10).

### Estoque baixo
- Use o relatório **Reposição** para ver os itens abaixo do mínimo.
- A página inicial também mostra **Sem estoque** e **Estoque baixo**.

### Atualizar
- Edite o item a qualquer momento para mudar o mínimo.
- Ajuste conforme a velocidade de venda ou a estação.

### Dicas
- Use um mínimo maior para itens de venda rápida ou importantes.
- Revise os valores com frequência para os alertas continuarem úteis.
""",
  );
}
