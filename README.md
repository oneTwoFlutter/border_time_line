## 时间轴是前端UI经常用的，先看下效果图:

<div align=center><img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8e37ab2f580c47f08be50d7242edb43f~tplv-k3u1fbpfcp-watermark.image"></div>  

> ##### 时间轴的特点  
> 1、在列表中的高度不确定，高度取决于右侧 item 的高度  
> 2、时间轴通常在第一个 item 中的样式和其他 item 中不同。

## 实现  

### 一、借助 Container 中 decoration 属性，设置左侧的 border，可以实现时间轴高度随着 item 变化效果

```dart  
      Center(
          child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
        // 设置 BoxDecoration 的 border, border  的高度就是 Container 的高度
          border: Border(left: BorderSide(color: Colors.red)),
          color: Color(0x11000000),
        ),
      ))
```

##### 效果(图中红线是 Container 左侧的 border，可以在这里扩展成 timeline) :

<div align=center><img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0217b28b8f8c46c1a3c35702ab5c6b2c~tplv-k3u1fbpfcp-watermark.image" width="50%"></div>

### 二、重写 BorderDirectional 中 paint 方法 
BorderDirectional 中原来的 paint 方法，可以看出，设置不同的属性，会调用不同的绘制方法实现不同的效果，这里重新 paint 方法，实现时间轴的效果
<div align=center><img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/84f6ae3d2a614f4691148bfe9c33d948~tplv-k3u1fbpfcp-zoom-1.image" width="70%"></div>


> ##### paint 方法中参数  
> canvas ： 这个就是画布了，借助这个 canvas 可以随意实现各种效果  
> rect : Container 的范围大小


我们的 paint 方法实现，按照 UI 设计图，对应的位置画上圆和线就可以了
```dart  
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection, BoxShape shape = BoxShape.rectangle, BorderRadius? borderRadius}) {
    if (position != 1) {
      canvas.drawLine(Offset(rect.left+margin + radius / 2, rect.top), Offset(rect.left +margin+ radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius,_strokePaint());
    } else {
      canvas.drawLine(Offset(rect.left+margin + radius / 2, rect.top + radius * 2), Offset(rect.left+margin + radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left+margin + radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius, _strokePaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius / 2, _strokePaint());
    }
  }
```
#### 最终效果  
  
<div align=center><img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ca1d7c53d60743079ece69bee3be3dfb~tplv-k3u1fbpfcp-watermark.image" width="75%"></div>


### 三、完整代码

```dart
class BorderTimeLine extends BorderDirectional {
  int position;

  BorderTimeLine(this.position);

  double radius = 10;
  double margin= 20;
  Paint _paint = Paint()
    ..color = Color(0xFFDDDDDD)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection, BoxShape shape = BoxShape.rectangle, BorderRadius? borderRadius}) {
    if (position != 0) {
      canvas.drawLine(Offset(rect.left+margin + radius / 2, rect.top), Offset(rect.left +margin+ radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius,_strokePaint());
    } else {
      canvas.drawLine(Offset(rect.left+margin + radius / 2, rect.top + radius * 2), Offset(rect.left+margin + radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left+margin + radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius, _strokePaint());
      canvas.drawCircle(Offset(rect.left +margin+ radius / 2, rect.top + radius * 2), radius / 2, _strokePaint());
    }
  }

  Paint _fillPaint(){
    _paint.color=Colors.white;
    _paint.style=PaintingStyle.fill;
    return _paint;
  }
  Paint _strokePaint(){
    _paint.color=Color(0xFFDDDDDD);
    _paint.style=PaintingStyle.stroke;
    return _paint;
  }
}
```

#### 在 ListView 中的 item 中使用  
```dart
  Widget _buildItem(BuildContext c, int i) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(border: BorderTimeLine(i)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Divider(color: Colors.grey.shade300, thickness: 40),
            Text("$i" * 6, style: TextStyle(color: Colors.black, fontSize: 16)),
            Text("abc\n" * Random().nextInt(10)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ]),
        ));
  }
```



