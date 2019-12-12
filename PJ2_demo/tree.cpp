#include <iostream>
#include <string>
#include "tree.h"
using namespace std;

node_t* create_node(string name, string info = "", double value = .0){
    node_t* node = new node_t;
    node->name = name;
    node->line = 0; // TODO:
    node->col = 0; // TODO:
    node->info = info;
    node->value = value;
    node->parent = nullptr;
    return node;
}

void node_t::add_child(node_t* child) {
    childs.push_back(child);
    child->parent = this;
}

void node_t::show(){ 
    cout << "{ name: '" << name << "', line: '" << line <<"', col: '"<<col<<"', info: '"<<info<<"', ";
    if (childs.size() != 0) {
        cout << "\nchildren: [" << endl;
        for (int i = 0; i < childs.size(); i++) {
            childs[i]->show();
            cout << ","; 
        }
        cout << " ]";
    }
    cout << " }" << endl;
}

// int main() {
//     node_t* node1 = create_node("identifier", "X");
//     node1->line = 4;
//     node1->col = 15;
//     node_t* node2 = create_node("identifier", "INT");
//     node1->line = 4;
//     node1->col = 19;
//     node_t* node3 = create_node("identifier", "FOO");
//     node1->line = 4;
//     node1->col = 13;
//     node_t* node4 = create_node("component");
//     node1->line = 4;
//     node1->col = 27;
//     node4->add_child(node1);
//     node4->add_child(node2);
//     node_t* root = create_node("procedure_decl");
//     root->line = 9;
//     root->col = 5;
//     root->add_child(node3);
//     root->add_child(node4);

//     root->show();
// }
