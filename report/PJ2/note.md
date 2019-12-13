- 优先级，越后面越高，所以把二元token放后面
- 树可视化用生态树：https://g6.antv.vision/zh/examples/tree/dendrogram，树节点考虑用模态矩形https://g6.antv.vision/zh/examples/shape/basic#modelRect，动态展开用https://g6.antv.vision/zh/examples/interaction/loadData
- 如何将list从多级节点转为同级：
  - type-list: %empty { $$ = nullptr } | type-list type {  }
  - 匹配到empty，$$ = nullptr
  - 若子节点为列表节点且不为空，抢了他的子节点
  - 原本是想全部展开，但看例子貌似要留下一级list
  - 

- 貌似不用显示关键字、分隔符
- 两个不确定要不要做：
  - list加完孩子后若发现只有一个孩子，就把自己变成非list
  - 比如扩展成()，但是(、)都不显示，那它显不显示？
  - 若为X->关键字 Y，decl

- value本来是给计算用的，后来发现并不要求，就暂时用不到了

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

- 暂时不知道需不需要做BOOLEAN: TRUE/FALSE 5.2

- flex文件必须能返回所有的token

- 词法分析错误暂时强行返回ERR中断程序，后面看看能不能更优雅

- BEGIN被占用了，改成RK_BEGIN

- TODO:
  - 将词法报错移过来
  - 位置
  - 错误处理