<script lang="ts" context="module">
    /*
    // Is there a good source of *supported* formats? If not, limiting to a partial list could be worse than just
    // allowing everything.
    const imgMimeTypes = new Set([
      "image/apng",
      "image/avif",
      "image/gif",
      "image/jpeg",
      "image/png",
      "image/svg+xml",
      "image/webp",
      "image/bmp",
      "image/x-icon",
      "image/tiff",
    ]);
    */

    export function isMimeTypeImage(mt: string) {
        return mt.startsWith("image/");
    }

    export function isMimeTypeVideo(mt: string) {
        return mt.startsWith("video/");
    }

    export function isMimeTypeAudio(mt: string) {
        return mt.startsWith("audio/");
    }

    export function isMimeTypeText(mt: string) {
        return mt.startsWith("text/");
    }

    export function isMimeTypePDF(mt: string) {
        return mt == "application/pdf";
    }

    export function isMimeTypeSupported(mt: string) {
        return (
            isMimeTypeImage(mt) ||
            isMimeTypeVideo(mt) ||
            isMimeTypeAudio(mt) ||
            isMimeTypePDF(mt) ||
            isMimeTypeText(mt)
        );
    }

    export function getIcon(mimeType: string, isLink: boolean): string[] {
        // quick and dirty
        const icons: Record<string, string> = globalThis.icons;
        const icon: string = icons[
            mimeType == "#directory" ? "directory" :
            isMimeTypeImage(mimeType) ? "file-image" :
            isMimeTypeVideo(mimeType) ? "file-video" :
            isMimeTypeAudio(mimeType) ? "file-audio" :
            isMimeTypeText(mimeType) ? "file-text" :
            isMimeTypePDF(mimeType) ? "file-pdf" :
            "file" // default. also symlinks
        ];
        return (
            mimeType == "#unresolved" ? [icon, "invalidLink", "🔗 "] :
            isLink ? [icon, "link", "🔗 "] :
            [icon, null, ""]
        );
    }
</script>
