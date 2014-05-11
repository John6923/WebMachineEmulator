part of webmachineemulator;

void setupSimulator(){
  makeMemoryTable();
  //setupMemoryTable();
  makeRegisterTable();
  //setupRegisterTable();
  //setupSimulatorButtons();
}

void makeMemoryTable() {
  DivElement container = querySelector("#memory_container");
  StringBuffer buffer = new StringBuffer();
  buffer.write('<table>');
  for (int i = 0; i < 16; i++) {
    String rowLabel = '0x${(i*16).toRadixString(16)}';
    buffer.write('<tr><th id=\"editorLabel$i\">$rowLabel</th>');
    for (int j = 0; j < 16; j++) {
      buffer.write('<td class=\"simulatorCell\" id=\"simulatorCell${(i * 16 + j).toRadixString(16)}\">');
      buffer.write('<input type=\"text\" class=\"byteInput\" id=\"simulatorField${(i * 16 + j).toRadixString(16)}\"  disabled/>');
      buffer.write('</td>');
    }
    buffer.write('</tr>');
  }
  buffer.write('</table>');
  container.innerHtml = buffer.toString();
}

void makeRegisterTable() {
  DivElement container = querySelector("#register_container");
  StringBuffer buffer = new StringBuffer();
  buffer.write('<table>');
  buffer.write("<tr>");
  for (int i = 0; i < 16; i++) {
    String registerLabel = '0x${(i).toRadixString(16)}';
    buffer.write('<th id=\"registerLabel$i\">$registerLabel</th>');
  }
  buffer.write('</tr><tr>');
  for (int j = 0; j < 16; j++) {
    buffer.write('<td class=\"registerCell\" id=\"registerCell${(j).toRadixString(16)}\">');
    buffer.write('<input type=\"text\" class=\"byteInput\" id=\"registerField${(j).toRadixString(16)}\"  disabled/>');
    buffer.write('</td>');
  }
  buffer.write('</tr>');
  buffer.write('</table>');
  container.innerHtml = buffer.toString();
}
