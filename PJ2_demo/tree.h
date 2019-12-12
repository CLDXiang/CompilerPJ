#include <string>
#include <vector>
using namespace std;

struct node_t { 
    string name;
    unsigned int line, col; // 行列号
    string info;
    double value; // 值

    vector<node_t*> childs;
    node_t* parent;

    void add_child(node_t* child);
    void show();
};

node_t* create_node();
