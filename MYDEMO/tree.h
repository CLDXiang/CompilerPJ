#ifndef __TREE_H_
#define __TREE_H_

#include <string>
#include <vector>
#include <initializer_list>
using namespace std;

struct Node { 
    string name;
    unsigned int line, col; // 行列号
    string info;
    double value; // 值
    bool isList; // 是否是列表节点（type-list）

    vector<Node*> childs;
    Node* parent;

    Node(string name_i, bool is_list = false, string info_i = "", double value_i = .0)
    : name(name_i), line(0), col(0), info(info_i), value(value_i), isList(is_list), parent(nullptr) {} // TODO: line & col

    void add_childs(initializer_list<Node*> new_childs);
    void show();
};

Node* create_node(string name, bool isList, string info , double value);

#endif