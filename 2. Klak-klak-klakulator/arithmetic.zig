const print = @import("std").debug.print;

pub fn addi32(a: i32, b: i32) i32 {
    // #NoLooping, but too lazy to think
    var res: i32 = 0;
    var carry: i32 = 0;

    var shcarry: i32 = 0;
    // #1 iteration: 1st LSByte
    carry = a & b;
    res = a ^ b;

    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;

    // #2 iteration: 2nd LSByte
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;

    // #3 iteration: 3rd LSByte
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;

    // #4 iteration: 4th LSByte
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;
    shcarry = carry << 1;
    carry = res & shcarry;
    res = res ^ shcarry;

    return res;
}

pub fn negi32(a: i32) i32 {
    const aNot: i32 = ~a;
    const aNeg: i32 = addi32(aNot, 1);
    return aNeg;
}

pub fn subi32(a: i32, b: i32) i32 {
    const bNeg: i32 = negi32(b);
    var res: i32 = addi32(a, bNeg);
    return res;
}

pub fn muli32(a: i32, b: i32) i32 {
    // uses comparison operator for efficiency, if not allowed then just loop 32 times just like add32
    var bCount: u32 = @bitCast(u32, b);
    var res: i32 = 0;
    var adder: i32 = a;
    while(bCount & 0xFFFFFFFF != 0) {   // else use subtraction and compare MSB with 1, but am too lazy
        if(bCount & 1 == 1) {
            res = addi32(res, adder);
        }
        adder = adder << 1;
        bCount = bCount >> 1;
    }
    return res;
}

const oneComplement32: i32 = -2147483648;
pub fn divi32(a: i32, b: i32) i32 {
    // remove negative
    var neg: bool = false;

    var dividend: i32 = 0;
    var divisor: i32 = 0;
    if (a & oneComplement32 == oneComplement32) {
        dividend = negi32(a);
        neg = !neg;
    }
    else {
        dividend = a;
    }

    if (b & oneComplement32 == oneComplement32) {
        divisor = negi32(b);
        neg = !neg;
    }
    else {
        divisor = b;
    }
    // uses comparison operator for efficiency, if not allowed then just loop 32 times just like add32
    var res: i32 = 0;

    var tempremainder: i32 = 0;
    var i: i32 = 0;
    while (i<32): (i+=1) {
        tempremainder = tempremainder << 1;
        if(dividend & oneComplement32 == oneComplement32){
            tempremainder = tempremainder | 1;
        }
        dividend = dividend << 1;
        res = res << 1;
        
        var tempsub: i32 = subi32(tempremainder, divisor);
        if(tempsub & oneComplement32 == 0) {
            res = res | 1;
            tempremainder = tempsub;
        }
    }

    if(neg) {
        res = negi32(res);
    }
    return res;
}
