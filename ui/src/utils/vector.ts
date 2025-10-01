export class Vector3 {
    x: number;
    y: number;
    z: number;

    constructor(x: number | {x: number, y: number, z: number}, y?: number, z?: number) {
        if (typeof x === 'object') {
            this.x = x.x;
            this.y = x.y;
            this.z = x.z;
        } else {
            this.x = x;
            this.y = y!;
            this.z = z!;
        }
    }
    
    subtract(other: Vector3 | {x: number, y: number, z: number}): Vector3 {
        return new Vector3(this.x - other.x, this.y - other.y, this.z - other.z);
    }
    
    magnitude(): number {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }

    distance_to(other: Vector3 | Vector4 | {x: number, y: number, z: number}): number {
        return this.subtract(other).magnitude();
    }
}

export class Vector4 {
    x: number;
    y: number;
    z: number;
    w: number;
    
    constructor(x: number | {x: number, y: number, z: number, w: number}, y?: number, z?: number, w?: number) {
        if (typeof x === 'object') {
            this.x = x.x;
            this.y = x.y;
            this.z = x.z;
            this.w = x.w;
        } else {
            this.x = x;
            this.y = y!;
            this.z = z!;
            this.w = w!;
        }
    }
    
    toVector3(): Vector3 {
        return new Vector3(this.x, this.y, this.z);
    }   
    
    subtract(other: Vector4 | {x: number, y: number, z: number, w: number}): Vector4 {
        return new Vector4(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);
    }
    
    magnitude(): number {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
    }

    distance_to(other: Vector4 | Vector3 | {x: number, y: number, z: number, w?: number}): number {
        if (other instanceof Vector3 || (!('w' in other) || other.w === undefined)) {
            return this.toVector3().distance_to(other as Vector3);
        }
        return this.subtract(other as Vector4).magnitude();
    }
}
