package com.juliaaano.rhdm;

import static java.util.stream.Collectors.toList;
import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Optional;

import com.juliaaano.rhdm.data.Greeting;
import com.juliaaano.rhdm.data.Person;

import org.junit.Test;
import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;

public class GreetingTest {

    @Test
    public void test_greeting_from_decision_table() {

        KieServices ks = KieServices.Factory.get();
        KieContainer kcontainer = ks.getKieClasspathContainer();

        KieSession ksession = kcontainer.newKieSession("StatefulKS");

        Person person = new Person();
        person.setName("James");

        ksession.insert(person);
        ksession.fireAllRules();

        Optional<Greeting> greeting = ksession.getObjects().stream().filter(object -> object instanceof Greeting)
                .map(object -> (Greeting) object).findAny();

        ksession.dispose();

        assertThat(greeting).isPresent();
        assertThat(greeting.get().getGreeting()).isEqualTo("Hey, James!");
    }

    @Test
    public void test_greeting_from_template() {

        KieServices ks = KieServices.Factory.get();
        KieContainer kcontainer = ks.getKieClasspathContainer();

        KieSession ksession = kcontainer.newKieSession("StatefulKS");

        Person robert = new Person();
        robert.setName("Robert");
        robert.setSurname("Jones");

        Person michael = new Person();
        michael.setName("Michael");
        michael.setSurname("Jones");

        ksession.insert(robert);
        ksession.insert(michael);
        ksession.fireAllRules();

        List<String> greetings = ksession.getObjects().stream().filter(obj -> obj instanceof Greeting)
                .map(obj -> ((Greeting) obj).getGreeting()).collect(toList());

        ksession.dispose();

        assertThat(greetings).hasSize(2);
        assertThat(greetings).contains("Whats up, Robert!", "Greetings, Michael!");
    }

    @Test
    public void test_greeting_from_drl() {

        KieServices ks = KieServices.Factory.get();
        KieContainer kcontainer = ks.getKieClasspathContainer();

        KieSession ksession = kcontainer.newKieSession("StatefulKS");

        Person person = new Person();
        person.setName("John");
        person.setSurname("Smith");

        ksession.insert(person);
        ksession.fireAllRules();

        Optional<Greeting> greeting = ksession.getObjects().stream().filter(object -> object instanceof Greeting)
                .map(object -> (Greeting) object).findAny();

        ksession.dispose();

        assertThat(greeting).isPresent();
        assertThat(greeting.get().getGreeting()).isEqualTo("Hello, John!");
    }
}