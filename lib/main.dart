// =====================================================================
//  CINECARD - catálogo de filmes
//  Atividade de faculdade: MANIPULAÇÃO DE IMAGENS no Flutter
//
//  Tudo está em um único arquivo (lib/main.dart) para facilitar a leitura.
//  Ordem do arquivo:
//    1. main() e o widget raiz (MaterialApp com tema escuro)
//    2. Modelo de dados "Filme" + lista fixa com 6 filmes
//    3. TELA 1: catálogo em cards (CatalogoScreen + CardFilme)
//    4. TELA 2: detalhe com botões de BoxFit (DetalheFilmeScreen)
//    5. Widgets auxiliares de erro e carregamento
//
//  Nenhum pacote externo é usado: apenas o Flutter (material.dart).
// =====================================================================

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------
// 1. PONTO DE ENTRADA
// ---------------------------------------------------------------------
void main() {
  // runApp "liga" o app: recebe o widget raiz e desenha na tela.
  runApp(const CineCardApp());
}

class CineCardApp extends StatelessWidget {
  const CineCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineCard',
      debugShowCheckedModeBanner: false, // tira a faixa "DEBUG" do canto
      // TEMA ESCURO com cara de cinema: fundo quase preto e detalhes
      // em âmbar (cor de letreiro / pipoca).
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
        cardTheme: const CardThemeData(color: Color(0xFF1C1C25)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F14),
          foregroundColor: Colors.amber,
        ),
      ),
      // A primeira tela que aparece é o catálogo.
      home: const CatalogoScreen(),
    );
  }
}

// ---------------------------------------------------------------------
// 2. MODELO DE DADOS
// Uma classe simples que guarda as informações de UM filme.
// ---------------------------------------------------------------------
class Filme {
  final String titulo;
  final int ano;
  final String genero;
  final String sinopse;
  final double nota; // de 0 a 10
  final String urlPoster; // imagem DA WEB  -> usada com Image.network
  final String diretor;
  final String fotoDiretorAsset; // imagem LOCAL -> usada com Image.asset

  const Filme({
    required this.titulo,
    required this.ano,
    required this.genero,
    required this.sinopse,
    required this.nota,
    required this.urlPoster,
    required this.diretor,
    required this.fotoDiretorAsset,
  });
}

// Lista fixa de filmes (em um app real viria de um banco/API).
// Os pôsteres são os oficiais, hospedados na Wikipédia (upload.wikimedia.org),
// que permite carregar as imagens de fora e funciona tanto no celular quanto
// no navegador. As imagens ficam no servidor deles: o app só aponta a URL.
const List<Filme> filmes = [
  Filme(
    titulo: 'Cidade de Deus',
    ano: 2002,
    genero: 'Drama / Crime',
    nota: 8.6,
    diretor: 'Fernando Meirelles',
    fotoDiretorAsset: 'assets/images/diretor_meirelles.png',
    urlPoster:
        'https://upload.wikimedia.org/wikipedia/pt/1/10/CidadedeDeus.jpg',
    sinopse:
        'Buscapé cresce em uma favela do Rio de Janeiro e sonha em ser '
        'fotógrafo, enquanto vê a violência tomar conta da comunidade.',
  ),
  Filme(
    titulo: 'Interestelar',
    ano: 2014,
    genero: 'Ficção Científica',
    nota: 8.7,
    diretor: 'Christopher Nolan',
    fotoDiretorAsset: 'assets/images/diretor_nolan.png',
    urlPoster:
        'https://upload.wikimedia.org/wikipedia/pt/3/3a/Interstellar_Filme.png',
    sinopse:
        'Com a Terra se tornando inabitável, um grupo de astronautas viaja '
        'por um buraco de minhoca em busca de um novo lar para a humanidade.',
  ),
  Filme(
    titulo: 'A Origem',
    ano: 2010,
    genero: 'Ação / Suspense',
    nota: 8.8,
    diretor: 'Christopher Nolan',
    fotoDiretorAsset: 'assets/images/diretor_nolan.png',
    urlPoster:
        'https://upload.wikimedia.org/wikipedia/pt/8/84/AOrigemPoster.jpg',
    sinopse:
        'Um ladrão especializado em roubar segredos dentro dos sonhos recebe '
        'a missão inversa: plantar uma ideia na mente de alguém.',
  ),
  // ---------------------------------------------------------------
  // FILME COM URL DO PÔSTER QUEBRADA (DE PROPÓSITO!)
  // O servidor responde 404 para esse endereço. Serve para mostrar o
  // errorBuilder em ação na apresentação: em vez de a tela quebrar,
  // aparece o ícone de filme + "Pôster indisponível".
  //
  // Para ver o pôster real depois da apresentação, troque a urlPoster por:
  // 'https://upload.wikimedia.org/wikipedia/pt/2/29/Central_do_Brasil_poster.jpg'
  // ---------------------------------------------------------------
  Filme(
    titulo: 'Central do Brasil',
    ano: 1998,
    genero: 'Drama',
    nota: 8.0,
    diretor: 'Walter Salles',
    fotoDiretorAsset: 'assets/images/diretor_salles.png',
    urlPoster: 'https://upload.wikimedia.org/poster-que-nao-existe.jpg',
    sinopse:
        'Dora, que escreve cartas para analfabetos na estação Central do '
        'Brasil, acaba viajando pelo Nordeste com um menino em busca do pai.',
  ),
  Filme(
    titulo: 'Parasita',
    ano: 2019,
    genero: 'Suspense / Drama',
    nota: 8.5,
    diretor: 'Bong Joon-ho',
    fotoDiretorAsset: 'assets/images/diretor_bong.png',
    urlPoster:
        'https://upload.wikimedia.org/wikipedia/pt/b/be/Parasite_poster.jpg',
    sinopse:
        'Uma família pobre se infiltra, um a um, na casa de uma família '
        'rica, até que um segredo no porão muda tudo.',
  ),
  Filme(
    titulo: 'O Auto da Compadecida',
    ano: 2000,
    genero: 'Comédia',
    nota: 8.6,
    diretor: 'Guel Arraes',
    fotoDiretorAsset: 'assets/images/diretor_arraes.png',
    urlPoster:
        'https://upload.wikimedia.org/wikipedia/pt/b/bf/O_auto_da_compadecida.jpg',
    sinopse:
        'João Grilo e Chicó, dois nordestinos pobres e espertos, vivem de '
        'pequenos golpes no sertão até serem julgados no céu.',
  ),
];

// ---------------------------------------------------------------------
// 3. TELA 1 - CATÁLOGO
// É um StatelessWidget porque essa tela não muda sozinha: ela só
// mostra a lista e navega para o detalhe ao tocar em um card.
// ---------------------------------------------------------------------
class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_movies),
            SizedBox(width: 8),
            Text('CineCard', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      // ListView.builder cria os cards sob demanda, um por filme.
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          return CardFilme(filme: filmes[index]);
        },
      ),
    );
  }
}

// Widget de UM card do catálogo. Separar em um widget deixa o código limpo.
class CardFilme extends StatelessWidget {
  final Filme filme;

  const CardFilme({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      // InkWell deixa o card "clicável" com efeito de toque.
      child: InkWell(
        onTap: () {
          // Navigator.push abre a TELA 2 por cima da TELA 1,
          // passando o filme que foi tocado.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheFilmeScreen(filme: filme),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------
              // PÔSTER DO FILME (imagem da WEB)
              //
              // Hero: animação de "voo" da imagem entre as duas telas.
              // O Flutter procura um Hero com a MESMA tag na tela de
              // destino e anima a imagem de uma posição para a outra.
              //
              // ClipRRect = "Clip Rounded Rect": recorta o filho em um
              // retângulo de cantos arredondados. A imagem continua
              // retangular, o ClipRRect só "esconde" os cantos.
              // -------------------------------------------------------
              Hero(
                tag: filme.titulo, // precisa ser única por filme
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    filme.urlPoster,

                    // DIMENSIONAMENTO FIXO NO CÓDIGO:
                    // 100 px de largura por 150 px de altura (proporção
                    // 2:3 de pôster), escritos direto no widget.
                    width: 100,
                    height: 150,

                    // BoxFit.cover: a imagem PREENCHE toda a caixa de
                    // 100x150 mantendo a proporção; o que sobra é cortado.
                    fit: BoxFit.cover,

                    // errorBuilder: se a URL falhar (404, sem internet...),
                    // o Flutter chama esta função e mostra o widget que ela
                    // devolver NO LUGAR da imagem. Assim a tela não quebra.
                    errorBuilder: (context, error, stackTrace) {
                      return const PosterIndisponivel(
                        largura: 100,
                        altura: 150,
                      );
                    },

                    // loadingBuilder: chamado várias vezes ENQUANTO baixa.
                    // Se "loadingProgress" for null, terminou: devolve o
                    // "child" (a imagem pronta). Senão, mostra o indicador.
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return IndicadorCarregamento(
                        largura: 100,
                        altura: 150,
                        progresso: loadingProgress,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // -------------------------------------------------------
              // TÍTULO, ANO, GÊNERO, NOTA E DIRETOR
              // -------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filme.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${filme.ano}  •  ${filme.genero}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 8),
                    // Nota com estrelinha âmbar.
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          filme.nota.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ---------------------------------------------------
                    // DIRETOR: CircleAvatar mostra uma imagem dentro de um
                    // círculo. "radius" é o raio: radius 16 = 32 px de
                    // diâmetro. backgroundImage recebe um ImageProvider;
                    // AssetImage carrega o arquivo LOCAL declarado no
                    // pubspec.yaml (é o que Image.asset usa por dentro).
                    // ---------------------------------------------------
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(filme.fotoDiretorAsset),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            filme.diretor,
                            style: TextStyle(color: Colors.grey[300]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 4. TELA 2 - DETALHE DO FILME
//
// Aqui usamos um StatefulWidget porque a tela TEM um estado que muda
// enquanto o app roda: o BoxFit escolhido pelo usuário. Toda vez que o
// usuário toca em um botão, chamamos setState() e o Flutter redesenha
// o pôster com o novo BoxFit.
// ---------------------------------------------------------------------
class DetalheFilmeScreen extends StatefulWidget {
  final Filme filme;

  const DetalheFilmeScreen({super.key, required this.filme});

  @override
  State<DetalheFilmeScreen> createState() => _DetalheFilmeScreenState();
}

class _DetalheFilmeScreenState extends State<DetalheFilmeScreen> {
  // ESTADO da tela: qual BoxFit está selecionado agora.
  // Começa em "contain" para o pôster inteiro aparecer.
  BoxFit _fitAtivo = BoxFit.contain;

  // Função chamada pelos botões. setState avisa o Flutter:
  // "o estado mudou, execute build() de novo". Sem setState a variável
  // até muda, mas a tela NÃO é redesenhada.
  void _trocarFit(BoxFit novoFit) {
    setState(() {
      _fitAtivo = novoFit;
    });
  }

  // Texto explicativo de cada BoxFit, mostrado embaixo dos botões.
  String get _explicacaoFit {
    switch (_fitAtivo) {
      case BoxFit.cover:
        return 'cover: preenche toda a moldura mantendo a proporção; '
            'as bordas que sobram são cortadas.';
      case BoxFit.contain:
        return 'contain: mostra a imagem inteira mantendo a proporção; '
            'sobram faixas vazias na moldura.';
      case BoxFit.fill:
        return 'fill: estica a imagem para ocupar a moldura toda, '
            'distorcendo a proporção.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // "widget.filme" acessa o filme recebido pelo StatefulWidget.
    final filme = widget.filme;

    return Scaffold(
      appBar: AppBar(title: Text(filme.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // PÔSTER GRANDE COM BOXFIT INTERATIVO
            //
            // A "moldura" (Container) tem tamanho fixo: 320 px de altura
            // e a largura toda da tela. Como a moldura é mais larga que
            // alta e o pôster é mais alto que largo, a diferença entre os
            // BoxFits fica bem visível:
            //   - contain: pôster inteiro no meio, faixas escuras dos lados
            //   - cover:   preenche tudo, corta o topo e a base do pôster
            //   - fill:    preenche tudo ESTICANDO o pôster (distorce)
            //
            // O Hero tem a MESMA tag do card, então o pôster "voa" do
            // card até aqui quando a tela abre.
            // ---------------------------------------------------------
            Hero(
              tag: filme.titulo,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 320,
                  width: double.infinity,
                  color: const Color(0xFF26262F),
                  child: Image.network(
                    filme.urlPoster,
                    // Aqui o fit NÃO é fixo: ele vem da variável de estado.
                    fit: _fitAtivo,
                    errorBuilder: (context, error, stackTrace) {
                      return const PosterIndisponivel(altura: 320);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return IndicadorCarregamento(
                        altura: 320,
                        progresso: loadingProgress,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ---------------------------------------------------------
            // BOTÕES QUE TROCAM O BOXFIT EM TEMPO DE EXECUÇÃO
            // ---------------------------------------------------------
            Row(
              children: [
                _botaoFit(BoxFit.cover, 'Cover'),
                const SizedBox(width: 8),
                _botaoFit(BoxFit.contain, 'Contain'),
                const SizedBox(width: 8),
                _botaoFit(BoxFit.fill, 'Fill'),
              ],
            ),
            const SizedBox(height: 10),

            // Indicador de QUAL BoxFit está ativo agora. O texto usa a
            // variável de estado, então muda junto com o setState.
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.crop, size: 18),
                  label: Text(
                    'BoxFit ativo: ${_fitAtivo.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _explicacaoFit,
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const Divider(height: 32),

            // ---------------------------------------------------------
            // INFORMAÇÕES DO FILME
            // ---------------------------------------------------------
            Text(
              filme.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  filme.nota.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${filme.ano}  •  ${filme.genero}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // DIRETOR - segunda forma de usar CircleAvatar: em vez de
            // "backgroundImage", passamos um "child" com Image.asset.
            // Image.asset é o widget que carrega a imagem LOCAL da pasta
            // assets/ (declarada no pubspec.yaml). O ClipOval recorta a
            // imagem em círculo para caber no avatar.
            // ---------------------------------------------------------
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: ClipOval(
                    child: Image.asset(
                      filme.fotoDiretorAsset,
                      width: 56, // tamanho fixo: 2 x radius
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Direção',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      filme.diretor,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sinopse',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              filme.sinopse,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Cria um botão para um BoxFit. Se for o ativo, aparece "preenchido"
  // (FilledButton); senão, aparece só com contorno (OutlinedButton).
  Widget _botaoFit(BoxFit fit, String rotulo) {
    final ativo = _fitAtivo == fit;
    return Expanded(
      child: ativo
          ? FilledButton(onPressed: () => _trocarFit(fit), child: Text(rotulo))
          : OutlinedButton(
              onPressed: () => _trocarFit(fit),
              child: Text(rotulo),
            ),
    );
  }
}

// ---------------------------------------------------------------------
// 5. WIDGETS AUXILIARES
// São usados por TODOS os Image.network do app, para não repetir código.
// ---------------------------------------------------------------------

// Mostrado pelo errorBuilder quando o pôster da web não carrega.
class PosterIndisponivel extends StatelessWidget {
  final double altura;
  final double? largura; // null = ocupa a largura disponível

  const PosterIndisponivel({super.key, required this.altura, this.largura});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      width: largura ?? double.infinity,
      color: const Color(0xFF26262F),
      // FittedBox com scaleDown: se o espaço for pequeno (ex.: o pôster
      // de 100x150 do card), o ícone + texto encolhem para caber.
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.movie, size: 40, color: Colors.grey),
              SizedBox(height: 6),
              Text('Pôster indisponível', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// Mostrado pelo loadingBuilder enquanto o pôster está baixando.
class IndicadorCarregamento extends StatelessWidget {
  final double altura;
  final double? largura;
  final ImageChunkEvent progresso;

  const IndicadorCarregamento({
    super.key,
    required this.altura,
    this.largura,
    required this.progresso,
  });

  @override
  Widget build(BuildContext context) {
    // Se o servidor informou o tamanho total, calculamos a porcentagem
    // (0.0 a 1.0). Se não informou, "value" fica null e o círculo gira
    // indefinidamente.
    final double? valor = progresso.expectedTotalBytes != null
        ? progresso.cumulativeBytesLoaded / progresso.expectedTotalBytes!
        : null;

    return Container(
      height: altura,
      width: largura ?? double.infinity,
      color: const Color(0xFF26262F),
      child: Center(
        child: CircularProgressIndicator(value: valor, color: Colors.amber),
      ),
    );
  }
}
