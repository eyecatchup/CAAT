source ./version.compile.variables.sh
./version.compile.pack.sh

CAAT_DST="/tmp/caat"

echo -e "\n\nCompilation process\n\n"

#
# define CAAT products files.
#
DST_FILE_NAME="${CAAT_DST}";

FILE_CAAT="${DST_FILE_NAME}-min.js"
FILE_CAAT_CSS="${DST_FILE_NAME}-css-min.js"
FILE_CAAT_BOX2D="${DST_FILE_NAME}-box2d-min.js"

#
# DST_FILE is a file name.
# This script will produce different target files as follow:
#   + DST_FILE.js
#   + DST_FILE-css.js
#   + DST_FILE-box2d.js
#
echo -e "" > "${FILE_CAAT}"
echo -e "" > "${FILE_CAAT_CSS}"
echo -e "" > "${FILE_CAAT_BOX2D}"

SOURCE_DIR=${CAAT_SOURCE_DIR}

#
# set compilation level
#
COMPILATION_LEVEL=$1
if [ "${COMPILATION_LEVEL}" ]; then
  if [[ "${COMPILATION_LEVEL}" == "simple" ]]; then
    echo -e "Compilation level set to simple"
    COMPILATION_LEVEL="SIMPLE_OPTIMIZATIONS"
  elif [[ "${COMPILATION_LEVEL}" == "advanced" ]]; then
    echo -e "Compilation level set to advanced"
    COMPILATION_LECEL="ADVANCED_OPTIMIZATIONS"
  elif [[ "${COMPILATION_LEVEL}" == "spaces" ]]; then
    echo -e "Compilation level set to white spaces"
    COMPILATION_LEVEL="WHITESPACE_ONLY"
  else
    echo -e "Compilation level unknown: '${COMPILATION_LEVEL}'. Change to SIMPLE_OPTIMIZATIONS"
    COMPILATION_LEVEL="SIMPLE_OPTIMIZATIONS"
  fi
else
  echo -e "Compilation level defaults to simple optimizations."
  COMPILATION_LEVEL="SIMPLE_OPTIMIZATIONS"
fi

#
# execute version procedure. 
# version.nfo contains new version value.
#
./version.sh
VERSION=`cat version.nfo`
echo -e "New generated version: ${VERSION}"
echo -e "Generated at: ${DST_FILE_NAME}"
echo -e "From files at: ${SOURCE_DIR}"

#
# create stub files for all CAAT products.
#
echo -e "/*" >> "${FILE_CAAT}"
cat LICENSE >> "${FILE_CAAT}"
echo -e "\nVersion: ${VERSION}\n" >> "${FILE_CAAT}"
echo -e "Created on:" >> "${FILE_CAAT}"
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" >> "${FILE_CAAT}"
echo -e "*/\n\n" >> "${FILE_CAAT}"

echo -e "/*" >> "${FILE_CAAT_CSS}"
cat LICENSE >> "${FILE_CAAT_CSS}"
echo -e "\nVersion: ${VERSION}\n" >> "${FILE_CAAT_CSS}"
echo -e "Created on:" >> "${FILE_CAAT_CSS}"
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" >> "${FILE_CAAT_CSS}"
echo -e "*/\n\n" >> "${FILE_CAAT_CSS}"

echo -e "/*" >> "${FILE_CAAT_BOX2D}"
cat LICENSE >> "${FILE_CAAT_BOX2D}"
echo -e "\nVersion: ${VERSION}\n" >> "${FILE_CAAT_BOX2D}"
echo -e "Created on:" >> "${FILE_CAAT_BOX2D}"
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" >> "${FILE_CAAT_BOX2D}"
echo -e "*/\n\n" >> "${FILE_CAAT_BOX2D}"


#
# Compile canvas/GL
#
echo -e "\nCreating CAAT canvas/webGL"
/usr/bin/java -jar ${CAAT_CLOSURE_PATH}/compiler.jar --compilation_level "${COMPILATION_LEVEL}" \
--js ${CAAT_BUILD_DIR}/caat.js \
 >> "${FILE_CAAT}"

#
# Compile box2d
#
echo -e "Creating CAAT Box2d"
 /usr/bin/java -jar ${CAAT_CLOSURE_PATH}/compiler.jar --compilation_level "${COMPILATION_LEVEL}" --js ${CAAT_BUILD_DIR}/caat-box2d.js >> "${FILE_CAAT_BOX2D}"

#
# Compile css
#
echo -e "Creating CAAT CSS"
echo -e "CAAT.__CSS__=1;" >> /tmp/__css.js
java -jar ${CAAT_CLOSURE_PATH}/compiler.jar --compilation_level "${COMPILATION_LEVEL}" \
 --js ${CAAT_BUILD_DIR}/caat-css.js >> "${FILE_CAAT_CSS}"

#
# Distribute resulting compiled files
#
echo -e "\nCopying:"
echo -e "\tCopying results to ${CAAT_BUILD_DIR}"
cp ${FILE_CAAT} ${CAAT_BUILD_DIR} 
cp ${FILE_CAAT_CSS} ${CAAT_BUILD_DIR} 
cp ${FILE_CAAT_BOX2D} ${CAAT_BUILD_DIR} 


#
# Generating JSDoc.
#
echo -e "\nGenerating JSDoc"
./version.compile.doc.sh