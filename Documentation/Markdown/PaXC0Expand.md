## PaXC0Expand

`PaXC0Expand` is an option for `PaXEvaluate`. If set to `True`, Package-X function `C0Expand` will be applied to the output of Package-X.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).

### Examples

```mathematica
PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}]
PaXEvaluate[%]
```

$$\text{C}_{001}\left(\overline{p}^2,\overline{p}^2,m^2,m^2,m^2,m^2\right)$$

![04ohum5f7la9s](img/04ohum5f7la9s.svg)

$$-\frac{9 m^2 \overline{p}^4 \;\text{C}_0\left(m^2,\overline{p}^2,\overline{p}^2,m^2,m^2,m^2\right)}{2 \left(m^2-4 \overline{p}^2\right)^2}+\frac{\overline{p}^6 \;\text{C}_0\left(m^2,\overline{p}^2,\overline{p}^2,m^2,m^2,m^2\right)}{\left(m^2-4 \overline{p}^2\right)^2}-\frac{m^6 \;\text{C}_0\left(m^2,\overline{p}^2,\overline{p}^2,m^2,m^2,m^2\right)}{2 \left(m^2-4 \overline{p}^2\right)^2}+\frac{3 m^4 \overline{p}^2 \;\text{C}_0\left(m^2,\overline{p}^2,\overline{p}^2,m^2,m^2,m^2\right)}{\left(m^2-4 \overline{p}^2\right)^2}-\frac{\sqrt{3} \pi  m^2 \overline{p}^2}{\left(m^2-4 \overline{p}^2\right)^2}-\frac{11 m^2}{36 \left(m^2-4 \overline{p}^2\right)}+\frac{\pi  \overline{p}^4}{\sqrt{3} \left(m^2-4 \overline{p}^2\right)^2}+\frac{19 \overline{p}^2}{18 \left(m^2-4 \overline{p}^2\right)}-\frac{7 m^2 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{3 \left(m^2-4 \overline{p}^2\right)^2}-\frac{\overline{p}^2 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{3 \left(m^2-4 \overline{p}^2\right)^2}+\frac{\sqrt{3} \pi  m^4}{4 \left(m^2-4 \overline{p}^2\right)^2}+\frac{2 m^4 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{3 \overline{p}^2 \left(m^2-4 \overline{p}^2\right)^2}-\frac{1}{12 \varepsilon }+\frac{1}{12} \left(-\log \left(\frac{\mu ^2}{m^2}\right)+\gamma -\log (4 \pi )+2 \log (2 \pi )\right)$$

The full result is a `ConditionalExpression`

```mathematica
PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}]
res = PaXEvaluate[%, PaXC0Expand -> True];
```

$$\text{C}_{001}\left(\overline{p}^2,\overline{p}^2,m^2,m^2,m^2,m^2\right)$$

```mathematica
res // Short
res // Last
```

$$\fbox{$\frac{1}{12} \left(-\log (4 \pi )+\gamma -\frac{1}{\varepsilon }\right)-\frac{1}{12} \log \left(\frac{\mu ^2}{m^2}\right)+\langle\langle 6\rangle\rangle +\frac{1}{6} \log (2 \pi )\text{ if }m^4-\langle\langle 1\rangle\rangle >0$}$$

$$m^4-4 m^2 \overline{p}^2>0$$

Use `Normal` to get the actual expression

```mathematica
(res // Normal)
```

$$\frac{1}{12} \left(-\log (4 \pi )+\gamma -\frac{1}{\varepsilon }\right)-\frac{1}{12} \log \left(\frac{\mu ^2}{m^2}\right)+\frac{\log \left(\frac{2 m^2-\overline{p}^2+\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}}{2 m^2}\right) \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \left(2 m^4-7 \overline{p}^2 m^2-\overline{p}^4\right)}{3 \left(m^2-4 \overline{p}^2\right)^2 \overline{p}^2}+\frac{\pi  \left(3 m^4-12 \overline{p}^2 m^2+4 \overline{p}^4\right)}{4 \sqrt{3} \left(m^2-4 \overline{p}^2\right)^2}-\frac{1}{2 \left(m^2-4 \overline{p}^2\right)^2}\left(m^6-6 \overline{p}^2 m^4+9 \overline{p}^4 m^2-2 \overline{p}^6\right) \left(-\frac{\text{Li}_2\left(\frac{-\left(\left(m^2-2 \overline{p}^2\right) m^2\right)-\sqrt{m^4-4 m^2 \overline{p}^2} m^2}{-\left(\left(m^2-2 \overline{p}^2\right) m^2\right)-\sqrt{3} \sqrt{-m^4} \sqrt{m^4-4 m^2 \overline{p}^2}}i \left(-m^2+2 \overline{p}^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}+\frac{\text{Li}_2\left(\frac{m^2 \sqrt{m^4-4 m^2 \overline{p}^2}-m^2 \left(m^2-2 \overline{p}^2\right)}{-\left(\left(m^2-2 \overline{p}^2\right) m^2\right)-\sqrt{3} \sqrt{-m^4} \sqrt{m^4-4 m^2 \overline{p}^2}}i \left(-m^2+2 \overline{p}^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}-\frac{\text{Li}_2\left(\frac{-\left(\left(m^2-2 \overline{p}^2\right) m^2\right)-\sqrt{m^4-4 m^2 \overline{p}^2} m^2}{\sqrt{3} \sqrt{-m^4} \sqrt{m^4-4 m^2 \overline{p}^2}-m^2 \left(m^2-2 \overline{p}^2\right)}+i \left(m^2-2 \overline{p}^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}+\frac{\text{Li}_2\left(\frac{m^2 \sqrt{m^4-4 m^2 \overline{p}^2}-m^2 \left(m^2-2 \overline{p}^2\right)}{\sqrt{3} \sqrt{-m^4} \sqrt{m^4-4 m^2 \overline{p}^2}-m^2 \left(m^2-2 \overline{p}^2\right)}+i \left(m^2-2 \overline{p}^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}-\frac{2 \;\text{Li}_2\left(\frac{m^2 \overline{p}^2-\overline{p}^2 \sqrt{m^4-4 m^2 \overline{p}^2}}{m^2 \overline{p}^2-\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \sqrt{m^4-4 m^2 \overline{p}^2}}+i \left(m^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}+\frac{2 \;\text{Li}_2\left(\frac{\overline{p}^2 m^2+\overline{p}^2 \sqrt{m^4-4 m^2 \overline{p}^2}}{m^2 \overline{p}^2-\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \sqrt{m^4-4 m^2 \overline{p}^2}}+i \left(m^2+\sqrt{m^4-4 m^2 \overline{p}^2}\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}-\frac{2 \;\text{Li}_2\left(\frac{m^2 \overline{p}^2-\overline{p}^2 \sqrt{m^4-4 m^2 \overline{p}^2}}{\overline{p}^2 m^2+\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \sqrt{m^4-4 m^2 \overline{p}^2}}i \left(\sqrt{m^4-4 m^2 \overline{p}^2}-m^2\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}+\frac{2 \;\text{Li}_2\left(\frac{\overline{p}^2 m^2+\overline{p}^2 \sqrt{m^4-4 m^2 \overline{p}^2}}{\overline{p}^2 m^2+\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \sqrt{m^4-4 m^2 \overline{p}^2}}i \left(\sqrt{m^4-4 m^2 \overline{p}^2}-m^2\right)\epsilon \right)}{\sqrt{m^2 \left(m^2-4 \overline{p}^2\right)}}\right)-\frac{11 m^2-38 \overline{p}^2}{36 \left(m^2-4 \overline{p}^2\right)}+\frac{1}{6} \log (2 \pi )$$