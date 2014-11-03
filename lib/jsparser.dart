library javascript_parser;

import 'dart:io';
import 'dart:async';

import 'src/ast.dart';
import 'src/lexer.dart';
import 'src/parser.dart';

export 'src/ast.dart';
export 'src/lexer.dart' show ParseError;

Program parse(String text, {String filename, int firstLine : 1, bool detectHashBang : true}) {
  int index = 0;
  if (detectHashBang && text.startsWith('#!')) {
    for (int i=0; i<text.length; i++) {
      if (isEOL(text.codeUnitAt(i))) {
        index = i;
        break;
      }
    }
  }
  Program program = new Parser(new Lexer(text, filename: filename, currentLine: firstLine, index : index)).parseProgram();
  setParentPointers(program);
  return program;
}

Future<Program> parseFile(File file) => file.readAsString().then((String text) => parse(text, filename: file.path));


void setParentPointers(Node node, [Node parent]) {
  node.parent = parent;
  node.forEach((child) => setParentPointers(child, node));
}