## PaXDiscExpand

`PaXDiscExpand` is an option for `PaXEvaluate`. If set to `True`, Package-X function `DiscExpand` will be applied to the output
of Package-X thus replacing `DiscB` by its explicit form.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).

### Examples

```mathematica
PaVe[0, 0, 1, {SP[p, p], 0, m^2}, {m^2, m^2, m^2}]
PaXEvaluate[%]
```

$$\text{C}_{001}\left(0,\overline{p}^2,m^2,m^2,m^2,m^2\right)$$

$$-\frac{35 m^2}{36 \left(m^2-\overline{p}^2\right)}+\frac{2 \overline{p}^2}{9 \left(m^2-\overline{p}^2\right)}+\frac{m^2 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{2 \left(m^2-\overline{p}^2\right)^2}-\frac{\overline{p}^2 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{12 \left(m^2-\overline{p}^2\right)^2}+\frac{\pi  \left(9 \sqrt{3}+\pi \right) m^4}{36 \left(m^2-\overline{p}^2\right)^2}+\frac{m^4 \log ^2\left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{4 \left(m^2-\overline{p}^2\right)^2}+\frac{m^4 \sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)} \log \left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{3 \overline{p}^2 \left(m^2-\overline{p}^2\right)^2}-\frac{1}{12 \varepsilon }+\frac{1}{12} \left(-\log \left(\frac{\mu ^2}{m^2}\right)+\gamma -\log (4 \pi )+2 \log (2 \pi )\right)$$

```mathematica
PaVe[0, 0, 1, {SP[p, p], 0, m^2}, {m^2, m^2, m^2}]
PaXEvaluate[%, PaXDiscExpand -> False]
```

$$\text{C}_{001}\left(0,\overline{p}^2,m^2,m^2,m^2,m^2\right)$$

$$\frac{m^2 \overline{p}^2 \left(\Lambda (\overline{p}^2,m,m)\right)}{2 \left(m^2-\overline{p}^2\right)^2}-\frac{\overline{p}^4 \left(\Lambda (\overline{p}^2,m,m)\right)}{12 \left(m^2-\overline{p}^2\right)^2}+\frac{m^4 \left(\Lambda (\overline{p}^2,m,m)\right)}{3 \left(m^2-\overline{p}^2\right)^2}-\frac{m^2 \overline{p}^2 \left(-6 \log \left(\frac{\mu ^2}{m^2}\right)+6 \gamma -43+6 \log (\pi )\right)}{36 \left(m^2-\overline{p}^2\right)^2}+\frac{\overline{p}^4 \left(-3 \log \left(\frac{\mu ^2}{m^2}\right)+3 \gamma -8+3 \log (\pi )\right)}{36 \left(m^2-\overline{p}^2\right)^2}+\frac{m^4 \left(-3 \log \left(\frac{\mu ^2}{m^2}\right)+\pi ^2+9 \sqrt{3} \pi +3 \gamma -35-3 \log (4 \pi )+6 \log (2 \pi )\right)}{36 \left(m^2-\overline{p}^2\right)^2}+\frac{m^4 \log ^2\left(\frac{\sqrt{\overline{p}^2 \left(\overline{p}^2-4 m^2\right)}-\overline{p}^2+2 m^2}{2 m^2}\right)}{4 \left(m^2-\overline{p}^2\right)^2}-\frac{1}{12 \varepsilon }$$