package com.juliaaano.rhdm;

import org.kie.api.event.process.DefaultProcessEventListener;
import org.kie.api.event.process.ProcessNodeTriggeredEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogProcessEventListener extends DefaultProcessEventListener {

    private static final Logger log = LoggerFactory.getLogger(LogProcessEventListener.class);

    public LogProcessEventListener() {

        log.info("This listener has intialised.");
    }

    @Override
    public void beforeNodeTriggered(ProcessNodeTriggeredEvent event) {

        log.info("{} node triggered.", event.getNodeInstance().getNodeName());
    }
}