#include <iostream>
#include <string>
#include "tree.h"
using namespace std;


Node* create_node(string name, bool isList, string info, double value) {
    return new Node(name, isList, info, value);
}

void hide_node(Node* node) {
    node->display = false;
}

void Node::add_childs(initializer_list<Node*> new_childs) {
    for (auto child: new_childs) {
        if (child == nullptr)
            continue; // 跳过空的子节点
        if (child->isList && this->isList && child->name == this->name) {
            // 当前节点和子节点是同类列表节点，将子节点的孩子让渡给当前节点
        // if (child->isList) {
        //     // 子节点是列表节点，将子节点的孩子让渡给当前节点
            for (auto grandson: child->childs) {
                childs.push_back(grandson);
                grandson->parent = this;
            }
            // TODO: 可能后面会涉及到传递语义值之类的。 
        } else {
            // 子节点不是列表节点，正常操作
            childs.push_back(child);
            child->parent = this;
        }
    }
}

void set_location(Node* node, int first_line, int first_col, int last_line, int last_col) {
    node->first_line = first_line;
    node->first_col = first_col;
    node->last_line = last_line;
    node->last_col = last_col;
}


void Node::show(){ 
    // info不为空才会真的显示，这个交给前端
    cout << "{ name: '" << name << "', loc_first: '" << first_line << ":" << first_col << "', loc_last: '" << last_line << ":" << last_col << "', info: '" << info << "', ";
    if (childs.size() != 0) {
        cout << "\nchildren: [" << endl;
        for (auto child: childs) {
            if (child->display) {
                child->show();
                cout << ","; 
            }
        }
        cout << " ]";
    }
    cout << " }" << endl;
}


// int main() {
//     // Node* node1 = create_node("identifier", "X");
//     // node1->line = 4;
//     // node1->col = 15;
//     // Node* node2 = create_node("identifier", "INT");
//     // node1->line = 4;
//     // node1->col = 19;
//     // Node* node3 = create_node("identifier", "FOO");
//     // node1->line = 4;
//     // node1->col = 13;
//     // Node* node4 = create_node("component");
//     // node1->line = 4;
//     // node1->col = 27;
//     // node4->add_childs({node1});
//     // node4->add_childs({node2});
//     // Node* root = create_node("procedure_decl");
//     // root->line = 9;
//     // root->col = 5;
//     // root->add_childs({node3, node4});

//     Node* node1 = create_node("d1");
//     Node* node2 = create_node("d2");
//     Node* node3 = create_node("d3");
//     Node* node4 = create_node("d4");
//     Node* nodee = nullptr;
//     Node* node5 = create_node("n1", true);
//     node5->add_childs({node3, nodee});
//     Node* node6 = create_node("n2", true);
//     node6->add_childs({node2, node5});
//     Node* root = create_node("n3", true);
//     root->add_childs({node1, node6});

//     root->show();
// }
