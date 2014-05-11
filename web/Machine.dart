library Machine;

import 'dart:math' show pow;

class Machine{
  List<int> _main_memory;
  int _pc;
  List<int> _register;
  bool _halted;
  
  Machine(List<int> main_memory, {int pc}){
    _main_memory = main_memory;
    if(pc == null)
      pc = 0;
    else
      _pc = pc;
    _register = new List<int>(16);
    _halted = false;
  }
  
  void step(){
    if(_halted) 
      return;
    int opcode = (_main_memory[_pc]/16).floor();
    int operand1 = _main_memory[_pc]%16;
    int operand2 = (_main_memory[(_pc+1)%256]/16).floor();
    int operand3 = _main_memory[(_pc+1)%256]%16;
    _pc+=2;
    _pc%=256;
    switch(opcode){
      case 1: 
        _register[operand1] = _main_memory[(operand2 << 4) + operand3];
        break;
      case 2:
        _register[operand1] = (operand2 << 4) + operand3;
        break;
      case 3:
        _main_memory[(operand2 << 4) + operand3] = _register[operand1];
        break;
      case 4:
        _register[operand3] = _register[operand2];
        break;
      case 5:
        _register[operand1] = _add2(_register[operand2],_register[operand3]);
        break;
      case 6:
        _register[operand1] = _addf(_register[operand2],_register[operand3]);
        break;
      case 7:
        _register[operand1] = _register[operand2] | _register[operand3];
        break;
      case 8:
        _register[operand1] = _register[operand2] & _register[operand3];
        break;
      case 9:
        _register[operand1] = _register[operand2] ^ _register[operand3];
        break;
      case 0xA:
        _register[operand1] = _bsr(_register[operand1], operand3);
        break;
      case 0xB:
        if(_register[operand1] == _register[0]){
          _pc = (operand2 << 4) + operand3;
        }
        break;
      case 0xC:
        _halted = true;
        break;
    }
  }
  
  int _add2(int a, int b){
    int ret = a + b;
    if(ret > 255)
      ret -= 256;
    return ret;
  }
    
  int _addf(int a, int b){
    int numa = ((a>>7) == 1 ? -1 : 1) * (a % 16 << (a /16).floor() % 8);
    int numb= ((b>>7) == 1 ? -1 : 1) * (b % 16 << ((b /16).floor() % 8));
    int c = numa + numb;
    int i = 0;
    while((c / (2 << i)) >= (1 << 4))
      i++;
    return ((c < 0 ? 1 : 0) << 7) + (i << 4) + (c >> i);
  }
    
  int _bsr(int a, int b){
    int c;
    return (a / (c=pow(2, b).floor()) + (a % c)*pow(2, 8-b).floor()).floor();
  }
  
  bool get halted => _halted;
  
  List<int> get main_memory => _main_memory;
  List<int> get register => _register;
}
