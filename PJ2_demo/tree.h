#ifndef __TREE_H_
#define __TREE_H_

#include <string>
#include <vector>
#include <initializer_list>
using namespace std;

struct Node { 
    string name;
    string info;
    double value; // 值
    bool isList; // 是否是列表节点（type-list）
    bool display; // 是否展示到树结构中
    int first_line, first_col, last_line, last_col; 

    vector<Node*> childs;
    Node* parent;

    Node(string name_i, bool is_list = false, string info_i = "", double value_i = .0)
    : name(name_i), info(info_i), value(value_i), isList(is_list), parent(nullptr), display(true), first_line(0), first_col(0), last_line(0), last_col(0) {} // TODO: line & col

    void add_childs(initializer_list<Node*> new_childs);
    void show();
};

Node* create_node(string name, bool isList = false, string info = "", double value = .0);
void hide_node(Node* node);
void set_location(Node* node, int first_line, int first_col, int last_line, int last_col);

#endif