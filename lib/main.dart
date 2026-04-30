import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OddyRoomApp());
}

class OddyRoomApp extends StatelessWidget {
  const OddyRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OddyRoom',
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
    );
  }
}

class CharacterModel {
  final String name;
  final String personality;
  final List<List<Color?>> pixels;

  CharacterModel({
    required this.name,
    required this.personality,
    required this.pixels,
  });
}

List<CharacterModel?> apartmentRooms = List.generate(6, (_) => null);

List<String> roomMessages = List.generate(
  6,
      (_) => '아직 아무도 살지 않아요.',
);

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OddyRoom',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('내가 그린 이상한 친구들이 사는 방'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final firstRoomIndex = apartmentRooms.indexWhere((room) => room != null);

                if (firstRoomIndex != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                        character: apartmentRooms[firstRoomIndex]!,
                        roomIndex: firstRoomIndex,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomizeScreen()),
                  );
                }
              },
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class SelectRoomScreen extends StatelessWidget {
  final CharacterModel? character;

  const SelectRoomScreen({super.key, this.character});

  @override
  Widget build(BuildContext context) {
    final bool isMoveInMode = character != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      appBar: AppBar(
        title: Text(isMoveInMode ? '입주할 방 선택' : '방 선택'),
        backgroundColor: const Color(0xFFFFDFA3),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final roomCharacter = apartmentRooms[index];
                final isEmpty = roomCharacter == null;

                return GestureDetector(
                  onTap: () {
                    if (isEmpty) {
                      if (isMoveInMode) {
                        apartmentRooms[index] = character;
                        roomMessages[index] = '방에 막 입주했어요.';

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(
                              character: apartmentRooms[index]!,
                              roomIndex: index,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('아직 아무도 살지 않는 빈 방이에요.')),
                        );
                      }
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(
                          character: roomCharacter,
                          roomIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0A8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.brown.shade200, width: 2),
                    ),
                    child: isEmpty
                        ? Center(
                      child: Text(
                        '방 ${index + 1}\n빈 방',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            roomMessages[index],
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 70,
                          height: 88,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: CharacterBody(character: roomCharacter),
                          ),
                        ),
                        Text(
                          roomCharacter.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            color: const Color(0xFFFFF7E8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const StartScreen()),
                            (route) => false,
                      );
                    },
                    child: const Text('종료하기'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomizeScreen()),
                      );
                    },
                    child: const Text('새 캐릭터 추가'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CharacterModel character;
  final int roomIndex;

  const HomeScreen({
    super.key,
    required this.character,
    required this.roomIndex,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double characterX = 180;
  bool movingRight = true;
  String currentMessage = '방에 막 입주했어요.';

  CharacterModel? visitor;
  double visitorX = 520;

  bool isJumping = false;
  bool isJumpingNow = false;
  int hunger = 60;

  int happiness = 60;
  bool isSleeping = false;
  bool visitorJumping = false;

  final Map<String, List<String>> personalityMessages = {
    '멍함': [
      '방 한가운데서 멍하니 서 있어요.',
      '왜 여기 왔는지 까먹은 것 같아요.',
      '침대 앞에서 아무 생각 없이 서 있어요.',
      '조금 전까지 뭘 하려 했는지 잊은 듯해요.',
      '벽지를 보고 고개를 갸웃거리고 있어요.',
    ],
    '예민함': [
      '작은 소리에도 깜짝 놀라고 있어요.',
      '방 안의 물건 위치가 마음에 안 드는 것 같아요.',
      '누가 다녀간 흔적을 의심하고 있어요.',
      '조심스럽게 주변을 살피고 있어요.',
      '문 쪽을 계속 신경 쓰고 있어요.',
    ],
    '활발함': [
      '방 안을 신나게 돌아다니고 있어요.',
      '혼자 놀이를 만들어낸 것 같아요.',
      '러그 위에서 폴짝거리고 있어요.',
      '누가 안 불렀는데도 신나 있어요.',
      '방 전체를 놀이터라고 생각하는 듯해요.',
    ],
    '이상함': [
      '아무도 없는 곳에 인사하고 있어요.',
      '벽지 무늬와 대화 중이에요.',
      '침대 밑에 비밀 왕국을 세운 것 같아요.',
      '갑자기 중요한 척 고개를 끄덕였어요.',
      '방 구석에 뭔가 있다고 믿는 것 같아요.',
    ],
    '소심함': [
      '방 한쪽에서 조용히 눈치를 보고 있어요.',
      '말을 걸까 말까 고민하는 것 같아요.',
      '작게 손을 흔든 것 같기도 해요.',
      '조용한 구석이 마음에 드는 듯해요.',
      '살짝 기뻐 보이지만 티 내지 않으려 해요.',
    ],
    '장난꾸러기': [
      '뭔가 숨기고 모른 척하고 있어요.',
      '침대 밑에 장난감을 밀어 넣었어요.',
      '혼자 웃다가 갑자기 얌전한 척해요.',
      '방 안에 작은 함정을 만든 것 같아요.',
      '주인이 보자 아무 일도 없던 척해요.',
    ],
    '철학적임': [
      '창밖을 보며 존재에 대해 생각하고 있어요.',
      '왜 방은 방인지 고민하는 중이에요.',
      '침묵 속에서 큰 깨달음을 얻은 듯해요.',
      '러그 위에서 인생을 되돌아보고 있어요.',
      '아무것도 하지 않는 것의 의미를 생각해요.',
    ],
  };

  void interactWithVisitor() {
    if (visitor == null) return;

    final playMessages = [
      '${widget.character.name}와 ${visitor!.name}이/가 같이 방을 탐험하고 있어요.',
      '${visitor!.name}이/가 ${widget.character.name}에게 비밀 이야기를 들려줬어요.',
      '둘이 아무 말 없이 나란히 서 있어요. 어색하지만 평화로워요.',
      '${widget.character.name}와 ${visitor!.name}이/가 러그 위에서 놀고 있어요.',
      '${visitor!.name}이/가 잠깐 놀러왔다가 간식을 노리고 있어요.',
      '둘이 동시에 같은 곳을 바라보고 있어요. 뭔가 통한 것 같아요.',
    ];

    setState(() {
      currentMessage = playMessages[random.nextInt(playMessages.length)];
      roomMessages[widget.roomIndex] = currentMessage;
    });
  }

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    moveCharacter();
    checkVisitorOccasionally();
  }

  void moveCharacter() async {
    while (mounted) {
      final waitTime = 900 + random.nextInt(1800);
      await Future.delayed(Duration(milliseconds: waitTime));

      if (!mounted) return;

      setState(() {
        // 자연스럽게 이동
        final step = random.nextInt(81) - 40;
        characterX = (characterX + step).clamp(120, 760);

        // 성격 기반 대사
        if (random.nextBool()) {
          final list =
              personalityMessages[widget.character.personality] ??
                  personalityMessages['멍함']!;

          currentMessage = list[random.nextInt(list.length)];
          roomMessages[widget.roomIndex] = currentMessage;
        }

        hunger = (hunger - random.nextInt(4)).clamp(0, 100);
        happiness = (happiness - random.nextInt(3)).clamp(0, 100);

        if (hunger < 25 && random.nextInt(3) == 0) {
          currentMessage = '배고파요... 간식 주세요!';
          roomMessages[widget.roomIndex] = currentMessage;
        }

        if (happiness < 25 && hunger >= 25 && random.nextInt(4) == 0) {
          currentMessage = '조금 심심한 것 같아요... 놀아줄래요?';
          roomMessages[widget.roomIndex] = currentMessage;
        }

        if (currentMessage.contains('기분') ||
            currentMessage.contains('신나') ||
            currentMessage.contains('좋아')) {
          jumpCharacter();
        }

        // // 방문자 등장
        // final others = apartmentRooms
        //     .where((room) => room != null && room != widget.character)
        //     .cast<CharacterModel>()
        //     .toList();
        //
        // if (others.isNotEmpty && random.nextInt(5) == 0) {
        //   visitor = others[random.nextInt(others.length)];
        //   currentMessage = '${visitor!.name}이/가 놀러왔어요!';
        // }
      });
    }
  }

  Future<void> jumpCharacter() async {
    if (isJumpingNow) return; // 이미 점프 중이면 무시
    isJumpingNow = true;

    for (int i = 0; i < 2; i++) {
      if (!mounted) return;

      setState(() {
        isJumping = true;
      });

      await Future.delayed(const Duration(milliseconds: 220));

      if (!mounted) return;

      setState(() {
        isJumping = false;
      });

      await Future.delayed(const Duration(milliseconds: 120));
    }

    isJumpingNow = false;
  }

  Future<void> jumpTogether() async {
    if (isJumpingNow) return;
    isJumpingNow = true;

    for (int i = 0; i < 2; i++) {
      if (!mounted) return;

      setState(() {
        isJumping = true;
        visitorJumping = visitor != null;
      });

      await Future.delayed(const Duration(milliseconds: 220));

      if (!mounted) return;

      setState(() {
        isJumping = false;
        visitorJumping = false;
      });

      await Future.delayed(const Duration(milliseconds: 120));
    }

    isJumpingNow = false;
  }

  void showRandomMessage() {
    setState(() {
      final list = personalityMessages[widget.character.personality] ??
          personalityMessages['멍함']!;

      currentMessage = list[random.nextInt(list.length)];
      roomMessages[widget.roomIndex] = currentMessage;
    });
  }

  void setMessage(String message) {
    setState(() {
      currentMessage = message;
      roomMessages[widget.roomIndex] = message;
    });
  }

  void checkVisitorOccasionally() async {
    while (mounted) {
      final waitTime = 15000 + random.nextInt(15000); // 15~30초
      await Future.delayed(Duration(milliseconds: waitTime));

      if (!mounted) return;
      if (visitor != null) continue;

      final others = apartmentRooms
          .where((room) => room != null && room != widget.character)
          .cast<CharacterModel>()
          .toList();

      if (others.isNotEmpty && random.nextInt(3) == 0) {
        setState(() {
          visitor = others[random.nextInt(others.length)];
          currentMessage = '${visitor!.name}이/가 놀러왔어요!';
          roomMessages[widget.roomIndex] = currentMessage;
        });
      }
    }
  }

  Widget statusBar(String label, int value) {
    final safeValue = value.clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label $safeValue%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: safeValue / 100,
            minHeight: 9,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      appBar: AppBar(
        title: Text('방 ${widget.roomIndex + 1}'),
        backgroundColor: const Color(0xFFFFDFA3),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 980,
                child: Stack(
                  children: [
                    // 벽
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFFFFF1D6),
                      ),
                    ),

                    // 바닥
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 170,
                      child: Container(
                        color: const Color(0xFFE9B77E),
                      ),
                    ),

                    // 창문
                    Positioned(
                      left: 60,
                      top: 45,
                      child: Container(
                        width: 600,
                        height: 330,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBDE7FF),
                          border: Border.all(color: Colors.brown, width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '☁️',
                            style: TextStyle(fontSize: 34),
                          ),
                        ),
                      ),
                    ),

                    // 침대
                    Positioned(
                      left: 35,
                      bottom: 80,
                      child: Container(
                        width: 190,
                        height: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.brown, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '침대',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    // 책상
                    Positioned(
                      left: 350,
                      bottom: 95,
                      child: Container(
                        width: 160,
                        height: 75,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC98F5A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.brown, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '책상',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    // 러그
                    Positioned(
                      left: 560,
                      bottom: 55,
                      child: Container(
                        width: 210,
                        height: 75,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8C7FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),

                    // 문
                    Positioned(
                      left: 820,
                      bottom: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SelectRoomScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 95,
                          height: 175,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB67A45),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.brown, width: 3),
                          ),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text('●'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 말풍선
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      left: characterX - 70,
                      bottom: 270,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 190),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          currentMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),

                    // 캐릭터
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      left: characterX,
                      bottom: isJumping ? 145 : 105,
                      child: GestureDetector(
                        onTap: interactWithVisitor,
                        child: Column(
                          children: [
                            CharacterBody(character: widget.character),
                            const SizedBox(height: 4),
                            Text(
                              widget.character.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isSleeping)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        left: characterX + 70,
                        bottom: 255,
                        child: const Text(
                          'Zzz',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),

                    if (visitor != null)
                      Positioned(
                        left: visitorX,
                        bottom: visitorJumping ? 145 : 105,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              currentMessage = '${visitor!.name}이/가 잠깐 놀다가 돌아갔어요.';
                              visitor = null;
                            });
                          },
                          child: Column(
                            children: [
                              CharacterBody(character: visitor!),
                              const SizedBox(height: 4),
                              Text(
                                visitor!.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(14),
            color: const Color(0xFFFFE8BD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: statusBar('행복도', happiness)),
                    const SizedBox(width: 12),
                    Expanded(child: statusBar('배고픔', hunger)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSleeping = false;
                            hunger = (hunger + 35).clamp(0, 100);
                            happiness = (happiness + 8).clamp(0, 100);
                            currentMessage = '간식을 먹고 기분이 좋아졌어요!';
                            roomMessages[widget.roomIndex] = currentMessage;
                          });
                          jumpCharacter();
                        },
                        child: const Text('간식'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSleeping = false;
                            happiness = (happiness + 30).clamp(0, 100);
                            hunger = (hunger - 8).clamp(0, 100);
                            currentMessage = visitor == null
                                ? '신나게 놀고 있어요!'
                                : '${widget.character.name}와 ${visitor!.name}이/가 같이 놀고 있어요!';
                            roomMessages[widget.roomIndex] = currentMessage;
                          });

                          if (visitor != null) {
                            jumpTogether();
                          } else {
                            jumpCharacter();
                          }
                        },
                        child: const Text('놀기'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSleeping = true;
                            happiness = (happiness + 12).clamp(0, 100);
                            currentMessage = '졸려서 꾸벅꾸벅해요...';
                            roomMessages[widget.roomIndex] = currentMessage;
                          });
                        },
                        child: const Text('재우기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  static const int gridSize = 24;

  final TextEditingController nameController = TextEditingController();

  String personality = '멍함';
  Color selectedColor = Colors.black;
  bool bucketMode = false;

  final personalities = [
    '멍함',
    '예민함',
    '활발함',
    '이상함',
    '소심함',
    '장난꾸러기',
    '철학적임',
  ];

  final colorPalette = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  late List<List<Color?>> pixels;

  @override
  void initState() {
    super.initState();
    clearPixels();
  }

  void clearPixels() {
    pixels = List.generate(
      gridSize,
          (_) => List.generate(gridSize, (_) => null),
    );
  }

  void paintAtLocalPosition(Offset localPosition, Size size) {
    final cellW = size.width / gridSize;
    final cellH = size.height / gridSize;

    final col = (localPosition.dx / cellW).floor();
    final row = (localPosition.dy / cellH).floor();

    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return;

    setState(() {
      if (bucketMode) {
        fillBucket(row, col, pixels[row][col], selectedColor);
      } else {
        pixels[row][col] = selectedColor;
      }
    });
  }

  void fillBucket(int row, int col, Color? targetColor, Color newColor) {
    if (targetColor == newColor) return;

    final queue = <List<int>>[
      [row, col]
    ];

    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      final r = current[0];
      final c = current[1];

      if (r < 0 || r >= gridSize || c < 0 || c >= gridSize) continue;
      if (pixels[r][c] != targetColor) continue;

      pixels[r][c] = newColor;

      queue.add([r + 1, c]);
      queue.add([r - 1, c]);
      queue.add([r, c + 1]);
      queue.add([r, c - 1]);
    }
  }

  bool hasDrawing() {
    for (final row in pixels) {
      for (final pixel in row) {
        if (pixel != null) return true;
      }
    }
    return false;
  }

  void goNext() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해 주세요!')),
      );
      return;
    }

    if (!hasDrawing()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도트 얼굴을 그려 주세요!')),
      );
      return;
    }

    final copiedPixels = pixels.map((row) => List<Color?>.from(row)).toList();

    final character = CharacterModel(
      name: nameController.text.trim(),
      personality: personality,
      pixels: copiedPixels,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectRoomScreen(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const editorSize = 288.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      appBar: AppBar(
        title: const Text('캐릭터 만들기'),
        backgroundColor: const Color(0xFFFFDFA3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              '얼굴을 도트로 그려주세요',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              width: editorSize,
              height: editorSize,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) {
                  paintAtLocalPosition(
                    details.localPosition,
                    const Size(editorSize, editorSize),
                  );
                },
                onPanUpdate: (details) {
                  paintAtLocalPosition(
                    details.localPosition,
                    const Size(editorSize, editorSize),
                  );
                },
                onTapDown: (details) {
                  paintAtLocalPosition(
                    details.localPosition,
                    const Size(editorSize, editorSize),
                  );
                },
                child: CustomPaint(
                  painter: PixelEditorPainter(pixels),
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              bucketMode ? '페인트통 모드: 누른 곳과 연결된 칸을 채워요' : '브러시 모드: 드래그해서 그릴 수 있어요',
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: colorPalette.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.deepPurple
                            : Colors.black26,
                        width: selectedColor == color ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      bucketMode = !bucketMode;
                    });
                  },
                  icon: Icon(bucketMode ? Icons.format_paint : Icons.brush),
                  label: Text(bucketMode ? '브러시로 변경' : '페인트통'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      clearPixels();
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('전체 지우기'),
                ),
              ],
            ),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '캐릭터 이름',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: personality,
              decoration: const InputDecoration(
                labelText: '성격',
                border: OutlineInputBorder(),
              ),
              items: personalities.map((p) {
                return DropdownMenuItem(value: p, child: Text(p));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  personality = value!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: goNext,
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PixelEditorPainter extends CustomPainter {
  final List<List<Color?>> pixels;

  PixelEditorPainter(this.pixels);

  @override
  void paint(Canvas canvas, Size size) {
    final gridSize = pixels.length;
    final cellSize = size.width / gridSize;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final color = pixels[row][col];

        if (color != null) {
          final paint = Paint()..color = color;
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            paint,
          );
        }
      }
    }

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    for (int i = 0; i <= gridSize; i++) {
      final p = i * cellSize;
      canvas.drawLine(Offset(p, 0), Offset(p, size.height), gridPaint);
      canvas.drawLine(Offset(0, p), Offset(size.width, p), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CharacterBody extends StatelessWidget {
  final CharacterModel character;

  const CharacterBody({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 140),
            painter: CharacterLineBodyPainter(),
          ),

          Positioned(
            top: 10,
            child: SizedBox(
              width: 72,
              height: 72,
              child: PixelFace(pixels: character.pixels),
            ),
          ),
        ],
      ),
    );
  }
}

class PixelFace extends StatelessWidget {
  final List<List<Color?>> pixels;

  const PixelFace({super.key, required this.pixels});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PixelPainter(pixels),
    );
  }
}

class PixelPainter extends CustomPainter {
  final List<List<Color?>> pixels;

  PixelPainter(this.pixels);

  @override
  void paint(Canvas canvas, Size size) {
    final int gridSize = pixels.length;
    final double cellSize = size.width / gridSize;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final color = pixels[row][col];

        if (color != null) {
          final paint = Paint()
            ..color = color
            ..style = PaintingStyle.fill;

          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) => true;
}

class CharacterLineBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // // 머리 원
    // canvas.drawOval(
    //   Rect.fromLTWH(24, 4, 72, 72),
    //   paint,
    // );

    // 왼팔
    canvas.drawLine(
      const Offset(30, 65),
      const Offset(10, 68),
      paint,
    );

    // 오른팔
    canvas.drawLine(
      const Offset(90, 65),
      const Offset(110, 68),
      paint,
    );

    // 왼다리 (짧게)
    canvas.drawLine(
      const Offset(50, 76),
      const Offset(48, 105),
      paint,
    );

    // 오른다리 (짧게)
    canvas.drawLine(
      const Offset(70, 76),
      const Offset(72, 105),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 기존 BodyPainter를 참조하는 코드가 남아있을 경우를 대비한 빈 클래스
class BodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}