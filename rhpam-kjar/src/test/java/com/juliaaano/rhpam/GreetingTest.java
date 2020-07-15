package com.juliaaano.rhpam;

import static org.assertj.core.api.Assertions.assertThat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.juliaaano.rhpam.data.Greeting;
import com.juliaaano.rhpam.data.Person;
import org.jbpm.test.JbpmJUnitBaseTestCase;
import org.junit.Test;
import org.kie.api.KieServices;
import org.kie.api.io.ResourceType;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.manager.RuntimeEngine;
import org.kie.api.runtime.process.ProcessInstance;
import org.kie.api.runtime.process.WorkItem;
import org.kie.api.runtime.process.WorkItemHandler;
import org.kie.api.runtime.process.WorkItemManager;
import org.kie.api.task.TaskService;
import org.kie.api.task.model.TaskSummary;

public class GreetingTest extends JbpmJUnitBaseTestCase {

    @Test
    public void test_greeting_from_decision_table() {

        final KieServices ks = KieServices.Factory.get();
        final KieContainer kcontainer = ks.getKieClasspathContainer();

        final KieSession ksession = kcontainer.newKieSession("StatefulKS");

        ksession.getAgenda().getAgendaGroup("greetings").setFocus();

        final Person person = new Person();
        person.setName("James");

        final Greeting greeting = new Greeting();

        ksession.insert(person);
        ksession.insert(greeting);
        ksession.fireAllRules();

        ksession.dispose();

        assertThat(greeting.getGreeting()).isEqualTo("Morning James!");
    }

    @Test
    public void test_greeting_from_template() {

        final KieServices ks = KieServices.Factory.get();
        final KieContainer kcontainer = ks.getKieClasspathContainer();

        final KieSession ksession = kcontainer.newKieSession("StatefulKS");

        ksession.getAgenda().getAgendaGroup("greetings").setFocus();

        final Person robert = new Person();
        robert.setName("Robert");
        robert.setSurname("Jones");

        final Greeting greeting = new Greeting();

        ksession.insert(robert);
        ksession.insert(greeting);
        ksession.fireAllRules();

        ksession.dispose();

        assertThat(greeting.getGreeting()).isEqualTo("How are you, Robert?");
    }

    @Test
    public void test_greeting_from_drl() {

        final KieServices ks = KieServices.Factory.get();
        final KieContainer kcontainer = ks.getKieClasspathContainer();

        final KieSession ksession = kcontainer.newKieSession("StatefulKS");

        ksession.getAgenda().getAgendaGroup("greetings").setFocus();

        final Person person = new Person();
        person.setSurname("Smith");

        final Greeting greeting = new Greeting();

        ksession.insert(person);
        ksession.insert(greeting);
        ksession.fireAllRules();

        ksession.dispose();

        assertThat(greeting.getGreeting()).isEqualTo("Hello, Smith!");
    }

    public GreetingTest() {
        super(true, false);
    }

    @Test
    public void test_greeting_from_businessprocess() {

        final Map<String, ResourceType> resources = new HashMap<String, ResourceType>();

        resources.put("com/juliaaano/rhpam/process/my-process.bpmn", ResourceType.BPMN2);
        resources.put("com/juliaaano/rhpam/rule/rules.drl", ResourceType.DRL);

        addWorkItemHandler("Rest", new WorkItemHandler() {
            @Override
            public void executeWorkItem(WorkItem workItem, WorkItemManager manager) {
                System.out.println("executeWorkItem");
                manager.completeWorkItem(workItem.getId(), null);
            }
            @Override
            public void abortWorkItem(WorkItem workItem, WorkItemManager manager) {
                System.out.println("abortWorkItem");
            }
        });

        createRuntimeManager(resources);

        final RuntimeEngine runtimeEngine = getRuntimeEngine();

        final Map<String, Object> params = new HashMap<>();
        params.put("person", new Person("John", "Smith"));

        final ProcessInstance myprocess =
                runtimeEngine.getKieSession().startProcess("rhpam-quickstart.myprocess", params);

        final TaskService taskService = runtimeEngine.getTaskService();

        final List<TaskSummary> tasks =
                taskService.getTasksAssignedAsPotentialOwner("redhat", null);

        assertThat(tasks).hasSize(1);

        final TaskSummary task = tasks.get(0);

        taskService.start(task.getId(), "shadowman");
        taskService.complete(task.getId(), "shadowman", null);

        assertNodeTriggered(myprocess.getId(), "rules", "custom", "comments", "fetch", "print");

        disposeRuntimeManager();
    }
}
