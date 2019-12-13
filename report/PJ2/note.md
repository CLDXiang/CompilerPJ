- 优先级，越后面越高，所以把二元token放后面
- 树可视化用生态树：https://g6.antv.vision/zh/examples/tree/dendrogram，树节点考虑用模态矩形https://g6.antv.vision/zh/examples/shape/basic#modelRect
- 如何将list从多级节点转为同级：
  - type-list: %empty { $$ = nullptr } | type-list type {  }
  - 匹配到empty，$$ = nullptr
  - 若子节点为列表节点且不为空，抢了他的子节点

测试代码：

```cpp
Node* node1 = create_node("d1");
Node* node2 = create_node("d2");
Node* node3 = create_node("d3");
Node* node4 = create_node("d4");
Node* nodee = nullptr;
Node* node5 = create_node("n1", true);
node5->add_childs({node3, nodee});
Node* node6 = create_node("n2", true);
node6->add_childs({node2, node5});
Node* root = create_node("n3", true);
root->add_childs({node1, node6});
```

结果是root下只有d1,d2,d3，yes！

- 对于{A B}用a-b-list实现
- 对于[xxx]直接分成两个式子来实现


- 注意开始条件改下名！！！会被宏定义为整数！！

- 区分/和DIV