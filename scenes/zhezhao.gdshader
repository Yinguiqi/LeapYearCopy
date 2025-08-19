shader_type canvas_item;

uniform vec2 center = vec2(0.885, 0.5); // 中心点（归一化）
uniform float radius = 1; // 圆形遮罩半径

void fragment() {
    vec2 uv = UV;

    // 校正UV坐标，使坐标系变为正方形
    vec2 corrected_uv = uv;
    corrected_uv.x = uv.x * 1.77;


   float dist = distance(corrected_uv, center);

    if (dist > radius) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // 外圈黑色
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0); // 圆圈透明部分
    }
}