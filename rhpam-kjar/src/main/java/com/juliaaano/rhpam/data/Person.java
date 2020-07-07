package com.juliaaano.rhpam.data;

public class Person implements java.io.Serializable {

	private String name;
	private String surname;

	public Person() {
	}

	public java.lang.String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSurname() {
		return this.surname;
	}

	public void setSurname(String surname) {
		this.surname = surname;
	}
	
	@Override
    public String toString() {
        return "Person [name=" + name + ", surname=" + surname + "]";
    }

}