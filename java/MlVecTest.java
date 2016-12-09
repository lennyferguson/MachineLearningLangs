package ml.linalg;

import junit.framework.TestCase;

/**
 * Created by stewartcharles on 12/8/16.
 */
public class MlVecTest extends TestCase {
    private final MlVec u = new MlVec(1.0,1.0,1.0);
    private final MlVec v = new MlVec(1.0,2.0,3.0);

    public void testAdd() throws Exception {
        assertTrue(u.add(v).equals(new MlVec(2.0,3.0,4.0)));
    }

    public void testScalarAdd() throws Exception {
        assertTrue(u.add(1.0).equals(new MlVec(2.0,2.0,2.0)));
    }

    public void testSub() throws Exception {
        assertTrue(v.sub(u).equals(new MlVec(0.0,1.0,2.0)));
    }

    public void testScalarSub() throws Exception {
        assertTrue(u.sub(1.0).equals(new MlVec(0.0,0.0,0.0)));
    }

    public void testMul() throws Exception {
        assertTrue(v.mul(v).equals(new MlVec(1.0,4.0,9.0)));
    }

    public void testScalarMul() throws Exception {
        assertTrue(u.mul(2.0).equals(new MlVec(2.0,2.0,2.0)));
    }

    public void testDiv() throws Exception {
        assertTrue(v.div(v).equals(new MlVec(1.0,1.0,1.0)));
    }

    public void testScalarDiv() throws Exception {
        assertTrue(u.div(2.0).equals(new MlVec(0.5,0.5,0.5)));
    }

    public void testDot() throws Exception {
        assertTrue(u.dot(u).equals(3.0));
        assertTrue(u.dot(v).equals(6.0));
    }

    public void testEquals() throws Exception {
        assertTrue(u.equals(u));
        assertTrue(v.equals(v));
    }

}