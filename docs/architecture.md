\# Architecture (High-level)



GitHub Actions (runner)

&nbsp; |

&nbsp; | OIDC / azure/login

&nbsp; v

Azure Resource Manager

&nbsp; |

&nbsp; +--> VM Power actions (start/stop/restart/deallocate)

&nbsp; |

&nbsp; +--> Snapshot create/delete (OS disk snapshots + retention)

&nbsp; |

&nbsp; +--> Run Command invoke (executes PowerShell inside Windows VM)



