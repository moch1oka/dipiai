/*
 * Blacklist for GoodbyeDPI HTTP DPI circumvention tricks
 *
 * This is a simple domain hash table.
 * Domain records are added from a text file, where every
 * domain is separated with a new line.
 */
#include <windows.h>
#include <stdio.h>
#include <ctype.h>
#include "goodbyedpi.h"
#include "utils/uthash.h"
#include "utils/getline.h"

typedef struct blackwhitelist_record {
    const char *host;
    UT_hash_handle hh;   /* makes this structure hashable */
} blackwhitelist_record_t;

static blackwhitelist_record_t *blackwhitelist = NULL;

static int check_get_hostname(const char *host) {
    blackwhitelist_record_t *tmp_record = NULL;
    if (!blackwhitelist) return FALSE;

    HASH_FIND_STR(blackwhitelist, host, tmp_record);
    if (tmp_record) {
        debug("check_get_hostname found host\n");
        return TRUE;
    }
    debug("check_get_hostname host not found\n");
    return FALSE;
}

static int add_hostname(const char *host) {
    if (!host)
        return FALSE;

    char host_lower[HOST_MAXLEN + 1];
    size_t len = strlen(host);
    if (len > HOST_MAXLEN || len < 2)
        return FALSE;

    for (size_t i = 0; i < len; i++) {
        host_lower[i] = (char)tolower((unsigned char)host[i]);
    }
    host_lower[len] = '\0';

    if (check_get_hostname(host_lower)) {
        debug("Not added host %s\n", host_lower);
        return FALSE;
    }

    blackwhitelist_record_t *tmp_record = malloc(sizeof(blackwhitelist_record_t));
    if (!tmp_record)
        return FALSE;

    char *host_c = strdup(host_lower);
    if (!host_c) {
        free(tmp_record);
        return FALSE;
    }

    tmp_record->host = host_c;
    HASH_ADD_KEYPTR(hh, blackwhitelist, tmp_record->host,
                    strlen(tmp_record->host), tmp_record);
    debug("Added host %s\n", host_c);
    return TRUE;
}

int blackwhitelist_load_list(const char *filename) {
    char *line = malloc(HOST_MAXLEN + 1);
    size_t linelen = HOST_MAXLEN + 1;
    int cnt = 0;
    ssize_t read;

    FILE *fp = fopen(filename, "r");
    if (!fp) return FALSE;

    while ((read = getline(&line, &linelen, fp)) != -1) {
        /* works with both \n and \r\n */
        line[strcspn(line, "\r\n")] = '\0';

        /* Trim leading whitespace and skip comments/empty lines */
        char *p = line;
        while (*p && isspace((unsigned char)*p)) p++;
        if (*p == '\0' || *p == '#')
            continue;

        if (strlen(p) > HOST_MAXLEN) {
            printf("WARNING: host %s exceeds maximum host length and has not been added\n",
                p);
            continue;
        }
        if (strlen(p) < 2) {
            printf("WARNING: host %s is less than 2 characters, skipping\n", p);
            continue;
        }
        if (add_hostname(p))
            cnt++;
    }
    free(line);
    fclose(fp);

    if (!blackwhitelist) return FALSE;
    printf("Loaded %d hosts from file %s\n", cnt, filename);
    return TRUE;
}

int blackwhitelist_check_hostname(const char *host_addr, size_t host_len) {
    char current_host[HOST_MAXLEN + 1];
    char *tokenized_host = NULL;

    if (host_len > HOST_MAXLEN || !host_addr || host_len == 0) return FALSE;
    for (size_t i = 0; i < host_len; i++) {
        current_host[i] = (char)tolower((unsigned char)host_addr[i]);
    }
    current_host[host_len] = '\0';

    if (check_get_hostname(current_host))
            return TRUE;

    tokenized_host = strchr(current_host, '.');
    while (tokenized_host != NULL && tokenized_host < (current_host + HOST_MAXLEN)) {
        if (check_get_hostname(tokenized_host + 1))
            return TRUE;
        tokenized_host = strchr(tokenized_host + 1, '.');
    }

    debug("____blackwhitelist_check_hostname FALSE: host %s\n", current_host);
    return FALSE;
}
