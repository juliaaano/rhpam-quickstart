package com.juliaaano.rhdm;

import org.kie.api.event.rule.DefaultAgendaEventListener;
import org.kie.api.event.rule.AfterMatchFiredEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogAgendaEventListener extends DefaultAgendaEventListener {

    private static final Logger log = LoggerFactory.getLogger(LogAgendaEventListener.class);

    public LogAgendaEventListener() {

        log.info("This listener has intialised.");
    }

    @Override
    public void afterMatchFired(AfterMatchFiredEvent event) {

        log.info("{} rule fired.", event.getMatch().getRule().getName());
    }
}