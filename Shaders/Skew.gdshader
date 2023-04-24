shader_type canvas_item;

uniform vec2 f_1;
uniform vec2 f_2;
uniform vec2 f_3;
uniform vec2 f_4;

vec2 sample_point(vec2 point) {
    float scaleX1 = f_2[0] - f_1[0];
    float scaleX2 = f_4[0] - f_3[0];
    float scaleY1 = f_3[1] - f_1[1];
    float scaleY2 = f_4[1] - f_2[1];
    
    float newX = (point.x * ((scaleX1 * (1.0f-point.y)) + scaleX2 * point.y)) + ((f_1[0] * (1.0f-point.y)) + (f_3[0] * point.y));
    float newY = (point.y * ((scaleY1 * (1.0f-point.x)) + scaleY2 * point.x)) + ((f_1[1] * (1.0f-point.x)) + (f_2[1] * point.x));
    
    return vec2(newX,newY);
}

void vertex() {
    VERTEX += sample_point(UV);
}