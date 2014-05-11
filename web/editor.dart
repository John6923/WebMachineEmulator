part of webmachineemulator;

final String STORAGE_KEY = "editorContents";

void setupEditor() {
  makeEditorTable();
  setupEditorTable();
  setupEditorButtons();
  loadChanges();
}

void makeEditorTable() {
  DivElement container = querySelector("#table_container");
  StringBuffer buffer = new StringBuffer();
  buffer.write('<table>');
  for (int i = 0; i < 16; i++) {
    String rowLabel = '0x${(i*16).toRadixString(16)}';
    buffer.write('<tr><th id=\"editorLabel$i\">$rowLabel</th>');
    for (int j = 0; j < 16; j++) {
      buffer.write('<td class=\"editorCell\" id=\"editorCell${(i * 16 + j).toRadixString(16)}\">');
      buffer.write('<input type=\"text\" class=\"byteInput\" id=\"editorField${(i * 16 + j).toRadixString(16)}\" />');
      buffer.write('</td>');
    }
    buffer.write('</tr>');
  }
  buffer.write('</table>');
  container.innerHtml = buffer.toString();
}

void setupEditorTable() {
  for (int i = 0; i < 16; i++) {
    for (int j = 0; j < 16; j++) {
      querySelector(getEditorId(j, i)).onChange.listen((_) {
        saveChanges();
      });
    }
  }
}

void setupEditorButtons() {
  ButtonElement startButton = querySelector("#start_button");
  startButton.onClick.listen(onStartButton);
  ButtonElement clearButton = querySelector("#clear_button");
  clearButton.onClick.listen(onClearButton);
  querySelector("#input_byte_button").onClick.listen(onInputByteButton);
  querySelector("#input_word_button").onClick.listen(onInputWordButton);
}

void onStartButton(Event e) {
 List<int> main_memory = new List<int>();
 bool wasError = false;
 StringBuffer errorCells = new StringBuffer();
 for(int i = 0; i < 256; i++){
   int x = i%16;
   int y = (i/16).floor();
   String cellContents = getCell(x,y);
   int value = 0;
   try {
     value = int.parse(cellContents, radix: 16);
   }
   catch(exception, stackTrace) {
     if(cellContents != "") {
      wasError = true;
      print('Format Error: x: $x y: $y string \"$cellContents\"');
      errorCells.write('0x${i.toRadixString(16)}, ');
     }
   }
   if(wasError){
     querySelector("#error").text = 'Format errors exist in following bytes: ${errorCells.toString()}';
   }
   main_memory.add(value);
 }
 //TODO: finish
}

void onClearButton(Event e) {
  print("clear\n");
  for (int i = 0; i < 16; i++) {
    for (int j = 0; j < 16; j++) {
      setCell(j, i, "");
    }
  }
  saveChanges();
}

void onInputByteButton(Event e) {
  String string = (querySelector("#input_field") as TextInputElement).value;
  if (string == null) return;
  List<String> ustrings = string.split(" ");
  List<String> strings = new List<String>();
  for (int j = 0; j < ustrings.length; j++) {
    String s = ustrings[j];
    if (s != "") {
      strings.add(s);
    }
  }
  int i;
  for (i = 0; i < strings.length && i < 256; i++) {
    setCell(i % 16, (i / 16).floor(), strings[i]);
  }
  for ( ; i < 256; i++) {
    setCell(i % 16, (i / 16).floor(), "");
  }
  saveChanges();
}

void onInputWordButton(Event e) {
  String string = (querySelector("#input_field") as TextInputElement).value;
  if (string == null) return;
  List<String> ustrings = string.split(" ");
  List<String> strings = new List<String>();
  for (int j = 0; j < ustrings.length; j++) {
    String s = ustrings[j];
    if (s != "") {
      strings.add(s);
    }
  }
  int i;
  for (i = 0; i < strings.length * 2 && i < 128; i+=2) {
    setCell(i % 16, (i / 16).floor(), strings[(i/2).floor()].substring(0,2));
    setCell(i % 16 + 1, (i / 16).floor(), strings[(i/2).floor()].substring(2));
  }
  for ( ; i < 256; i++) {
    setCell(i % 16, (i / 16).floor(), "");
  }
  saveChanges();
}

void saveChanges() {
  Map map = new Map();
  for (int i = 0; i < 16; i++) {
    for (int j = 0; j < 16; j++) {
      String elementId = getEditorId(j, i);
      map[elementId] = getCell(j, i);
    }
  }
  window.localStorage[STORAGE_KEY] = JSON.encode(map);
}

void loadChanges() {
  if (window.localStorage[STORAGE_KEY] == null) return;
  Map map = JSON.decode(window.localStorage[STORAGE_KEY]);
  for (int i = 0; i < 16; i++) {
    for (int j = 0; j < 16; j++) {
      String elementId = getEditorId(j, i);
      setCell(j, i, map[elementId]);
    }
  }
}

void setCell(int x, int y, String value) {
  String elementId = getEditorId(x, y);
  (querySelector(elementId) as TextInputElement).value = value;
}

String getCell(int x, int y) {
  String elementId = getEditorId(x, y);
  return (querySelector(elementId) as TextInputElement).value;
}

String getEditorId(int x, int y) {
  return '#editorField${(y*16 + x).toRadixString(16)}';
}
