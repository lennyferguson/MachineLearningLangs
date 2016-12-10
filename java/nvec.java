package ml.linalg;

import java.util.List;
import java.util.function.Function;

// Java MlVec class implemented for type 'Double'
public class MlVec {

    @FunctionalInterface
    interface Function2 {
        public Double apply(Double a, Double b);
    }

    @FunctionalInterface
    interface Function3 {
        public Double apply(Double a, Double b, Double c);
    }

    private Double[] data;

    public MlVec(List<Double> elems) {
        data = (Double[]) elems.toArray();
    }

    public MlVec(Double... elems) {
        data = elems;
    }

    public int length() { return data.length; }

    public Double get(int index) {
        return data[index];
    }

    public void set(int index, Double value) {
        data[index] = value;
    }

    public Double fold(MlVec rhs, Double accum, Function3 f) {
        for(int i = 0; i < this.length(); i++) {
            accum = f.apply(this.data[i],rhs.get(i),accum);
        }
        return accum;
    }

    public Double fold(Double accum, Function2 f) {
        for(int i = 0; i < this.length(); i++) {
            accum = f.apply(this.data[i],accum);
        }
        return accum;
    }

    public MlVec map(MlVec rhs, Function2 f) {
        MlVec v = new MlVec(new Double[this.length()]);
        for(int i = 0; i < this.length(); i++) {
            v.set(i, f.apply(this.data[i],rhs.get(i)));
        }
        return v;
    }

    public MlVec map(Function<Double,Double> f) {
        MlVec v = new MlVec(new Double[this.length()]);
        for(int i = 0; i < this.length(); i++) {
            v.set(i, f.apply(this.data[i]));
        }
        return v;
    }

    public MlVec add(MlVec rhs) {
        return this.map(rhs, (a,b) -> a + b);
    }

    public MlVec add(Double rhs) {
        return this.map((a) -> a + rhs);
    }

    public MlVec sub(MlVec rhs) {
        return this.map(rhs, (a,b) -> a - b);
    }

    public MlVec sub(Double rhs) {
        return this.map((a) -> a - rhs);
    }

    public MlVec mul(MlVec rhs) {
        return this.map(rhs, (a,b) -> a * b);
    }

    public MlVec mul(Double rhs) {
        return this.map((a) -> a * rhs);
    }

    public MlVec div(MlVec rhs) {
        return this.map(rhs, (a,b) -> a / b);
    }

    public MlVec div(Double rhs) {
        Double div = 1.0 / rhs;
        return this.map((a) -> a * div);
    }

    public Double dot(MlVec rhs) {
        return this.fold(rhs,0.0,(a,b,c) -> a * b + c);
    }

    public boolean equals(MlVec rhs) {
        return this.fold(rhs,0.0,(a,b,c) -> c + (a.equals(b) ? 1.0 : 0.0)) == this.length();
    }

    public static void main(String[] args) {

    }
}