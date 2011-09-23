package com.tw.keepin;

import com.xtremelabs.robolectric.*;
import org.junit.runners.model.InitializationError;

import java.lang.reflect.Method;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/2/11
 * Time: 9:25 AM
 * To change this template use File | Settings | File Templates.
 */
public class DBtestRunner extends RobolectricTestRunner {
    public DBtestRunner(Class<?> testClass) throws InitializationError {
        super(testClass);

    }

    @Override
    public void beforeTest(Method method) {
        super.beforeTest(method);    //To change body of overridden methods use File | Settings | File Templates.
        Robolectric.bindShadowClass(LocalShadowSQLiteDatabase.class);
    }

}
