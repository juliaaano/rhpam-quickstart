package com.juliaaano.rhpam.data;

@SuppressWarnings("serial")
public class Greeting implements java.io.Serializable {

    private String greeting;

    public Greeting() {
    }

    public Greeting(String greeting) {
        this.greeting = greeting;
    }

    public String getGreeting() {
        return this.greeting;
    }

    public void setGreeting(String greeting) {
        this.greeting = greeting;
    }

    @Override
    public String toString() {
        return "Greeting [greeting=" + greeting + "]";
    }
}
