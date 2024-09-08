﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настраивает форму документа согласно его виду.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//   documentType - ОбъектXDTO - вид документа.
//   organization - ОбъектXDTO - организация.
//
Процедура НастроитьФормуДокументаСогласноВидуДокументаXDTO(Форма, documentType, organization = Неопределено) Экспорт
	
	ИмяФормы = Форма.ИмяФормы;
	Элементы = Форма.Элементы;
	
	Если ИмяФормы = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ВходящийДокумент"
			Или ИмяФормы = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящийДокумент"
			Или ИмяФормы = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ВнутреннийДокумент" Тогда
		МодульИнтеграцияС1СДокументооборот = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияС1СДокументооборот");
		МодульИнтеграцияС1СДокументооборот.НастроитьФормуДокументаСогласноВидуДокументаXDTO(
			Форма,
			documentType,
			organization);
	КонецЕсли;
	
	ОтображатьПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
	НеОтображатьПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	
	Форма.АвтоматическаяНумерация = (documentType <> Неопределено И documentType.automaticNumeration = Истина);
	Если Форма.АвтоматическаяНумерация Тогда
		Элементы.РегистрационныйНомер.ОтображениеПредупрежденияПриРедактировании = ОтображатьПредупреждения;
		Элементы.ДатаРегистрации.ОтображениеПредупрежденияПриРедактировании = ОтображатьПредупреждения;
		Элементы.Зарегистрировать.Доступность = Истина;
	Иначе
		Элементы.РегистрационныйНомер.ОтображениеПредупрежденияПриРедактировании = НеОтображатьПредупреждения;
		Элементы.ДатаРегистрации.ОтображениеПредупрежденияПриРедактировании = НеОтображатьПредупреждения;
		Элементы.Зарегистрировать.Доступность = Ложь;
	КонецЕсли;
	
	Если documentType <> Неопределено
			И ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(documentType,
				"accountingForCaseFilesEnabled")
			И documentType.accountingForCaseFilesEnabled Тогда
		Элементы.НоменклатураДел.Видимость = Истина;
	Иначе
		Элементы.НоменклатураДел.Видимость = Ложь;
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1.CORP") Тогда
		
		Если Форма.Элементы.Дело.Видимость Тогда
			Если documentType <> Неопределено
					И ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(documentType, "accountingForCaseFilesEnabled")
					И documentType.accountingForCaseFilesEnabled Тогда
				Форма.Элементы.НоменклатураДел.Видимость = Истина;
			Иначе
				Форма.Элементы.НоменклатураДел.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Форма.Элементы.НоменклатураДел.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает набор дополнительных реквизитов объекта и помещает его на форму объекта.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   Форма - ФормаКлиентскогоПриложения - форма объекта 1С:Документооборота:
//     * Наименование - Строка
//
Процедура ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(Прокси, Форма) Экспорт
	
	Объект = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, Форма.Тип);
	Объект.name = Форма.Наименование;
	Объект.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		Форма.ID,
		Форма.Тип);
	
	Если Найти(Форма.Тип, "Document") > 0 Тогда
		Если ЗначениеЗаполнено(Форма.ВидДокумента) Тогда
			Объект.documentType = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, Форма.Тип + "Type");
			Объект.documentType.name = Форма.ВидДокумента;
			Объект.documentType.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
				Прокси,
				Форма.ВидДокументаID,
				Форма.ВидДокументаТип);
		КонецЕсли;
		
	ИначеЕсли Форма.Тип = "DMCorrespondent" Тогда
		Если ЗначениеЗаполнено(Форма.ЮрФизЛицо) Тогда
			Объект.legalPrivatePerson = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMLegalPrivatePerson");
			Объект.legalPrivatePerson.name = Форма.ЮрФизЛицо;
			Объект.legalPrivatePerson.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
				Прокси,
				Форма.ЮрФизЛицоID,
				Форма.ЮрФизЛицоТип);
		КонецЕсли;
		
	КонецЕсли;
		
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetObjectAdditionalPropertiesRequest");
	Запрос.object = Объект;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	ПоместитьДополнительныеРеквизитыНаФорму(Форма, Результат);
	
КонецПроцедуры

// Помещает набор дополнительных реквизитов объекта на форму объекта
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//   ОбъектXDTO - ОбъектXDTO - объект, из которого заполняются реквизиты формы.
//   ДопРеквизиты - СписокXDTO - массив дополнительных реквизитов, из которого заполняются реквизиты формы.
//
Процедура ПоместитьДополнительныеРеквизитыНаФорму(Форма, ОбъектXDTO = Неопределено,
		ДопРеквизиты = Неопределено) Экспорт
	
	Если ДопРеквизиты = Неопределено Тогда
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(ОбъектXDTO, "additionalProperties") Тогда
			ДопРеквизиты = ОбъектXDTO.additionalProperties; // СписокXDTO
		Иначе
			ДопРеквизиты = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	ЕстьСвойства = (ДопРеквизиты.Количество() > 0);
	
	// На некоторых формах для свойств выделена отдельная страница.
	Если Форма.Элементы.Найти("СтраницаСвойства") = Неопределено Тогда
		Форма.Элементы.ГруппаСвойства.Видимость = ЕстьСвойства;
	Иначе
		Форма.Элементы.СтраницаСвойства.Видимость = ЕстьСвойства;
	КонецЕсли;
	
	СтарыеЗначения = Форма.Свойства.Выгрузить();
	Форма.Свойства.Очистить();
	
	Если Не ЕстьСвойства Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДопСвойство Из ДопРеквизиты Цикл
		
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ДопСвойство, "propertyValueTypes") Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Форма.Свойства.Добавить();
		СписокДоступныхТипов = НоваяСтрока.СписокДоступныхТипов; // СписокЗначений
		
		НоваяСтрока.Свойство = ДопСвойство.name;
		НоваяСтрока.СвойствоТип = ДопСвойство.objectID.type;
		НоваяСтрока.СвойствоID = ДопСвойство.objectID.ID;
		
		Если ДопСвойство.Свойства().Получить("mandatory") <> Неопределено Тогда
			НоваяСтрока.ЗаполнятьОбязательно = ДопСвойство.mandatory;
		КонецЕсли;
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ДопСвойство, "propertySimpleValue") Тогда
			НоваяСтрока.Значение = ДопСвойство.propertySimpleValue;
		ИначеЕсли ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
				ДопСвойство, "propertyObjectValue") Тогда
			НоваяСтрока.Значение = ДопСвойство.propertyObjectValue.name;
			НоваяСтрока.ЗначениеТип = ДопСвойство.propertyObjectValue.objectID.type;
			НоваяСтрока.ЗначениеID = ДопСвойство.propertyObjectValue.objectID.ID;
		Иначе
			ПараметрыОтбора = Новый Структура("СвойствоТип, СвойствоID",
				НоваяСтрока.СвойствоТип,
				НоваяСтрока.СвойствоID);
			МассивСтрокСтарыеЗначения = СтарыеЗначения.НайтиСтроки(ПараметрыОтбора);
			Если МассивСтрокСтарыеЗначения.Количество() = 1 Тогда
				ЗаполнитьЗначенияСвойств(
					НоваяСтрока,
					МассивСтрокСтарыеЗначения[0],
					"Значение, ЗначениеТип, ЗначениеID");
			Иначе
				НоваяСтрока.Значение = "";
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого ОписаниеТипа Из ДопСвойство.PropertyValueTypes Цикл
			ДанныеОТипе = Новый Структура("xdtoClassName, presentation");
			ДанныеОТипе.xdtoClassName = ОписаниеТипа.xdtoClassName;
			ДанныеОТипе.presentation = ОписаниеТипа.presentation;
			СписокДоступныхТипов.Добавить(ДанныеОТипе);
		КонецЦикла;
		
	КонецЦикла;
	
	Форма.Элементы.Свойства.ВысотаВСтрокахТаблицы = ДопРеквизиты.Количество();
	
КонецПроцедуры

// Выполняет действия при изменении вида документа.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//   ДанныеОбъектовДО - СписокXDTO - содержит данные вида документа и, возможно, организации.
//
Процедура ПриИзмененииВидаНаФормеДокумента(Форма, ДанныеОбъектовДО = Неопределено) Экспорт
	
	organization = Неопределено;
	
	Если ДанныеОбъектовДО = Неопределено Тогда
		documentType = ВидДокументаXDTOПоФормеДокумента(Форма);
	Иначе
		documentType = ДанныеОбъектовДО[0];
		Если ДанныеОбъектовДО.Количество() > 1 И ДанныеОбъектовДО[1].objectID.type = "DMOrganization" Тогда
			organization = ДанныеОбъектовДО[1];
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПроверитьВозможностьСозданияДокументаНеПоШаблону(Форма, documentType) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуДокументаСогласноВидуДокументаXDTO(Форма, documentType, organization);
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(Прокси, Форма);
	
	Если ЗначениеЗаполнено(Форма.Тип) И ЗначениеЗаполнено(Форма.ID) Тогда
		ОбъектXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
			Прокси,
			Форма.Тип,
			Форма.ID,
			"registrationAvailable");
		УстановитьДоступностьРегистрации(Форма, ОбъектXDTO);
	КонецЕсли;
	
КонецПроцедуры

// Помещает значения дополнительных свойств в объект XDTO из формы объекта.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   ОбъектXDTO - ОбъектXDTO - заполняемый объект XDTO.
//   Форма - ФормаКлиентскогоПриложения, Структура - управляемая форма или структура реквизитов
//     документа 1С:Документооборота.
//
Процедура СформироватьДополнительныеСвойства(Прокси, ОбъектXDTO, Форма) Экспорт
	
	Для Каждого ДопСвойство Из Форма.Свойства Цикл
		
		ДополнительноеСвойство = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMAdditionalProperty");
		ДополнительноеСвойство.name = ДопСвойство.Свойство;
		
		ДополнительноеСвойство.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ДопСвойство.СвойствоID,
			ДопСвойство.СвойствоТип);
		
		Если ЗначениеЗаполнено(ДопСвойство.ЗначениеID) Тогда
			
			// Это значение объектного типа.
			ЭтоОбъектИС = Ложь;
			СсылкаНаПотребителя = ДопСвойство.Значение;
			Если Метаданные.НайтиПоПолномуИмени(ДопСвойство.ЗначениеТип) <> Неопределено Тогда
				ЭтоОбъектИС = Истина;
				СсылкаНаПотребителя = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СсылкаИзUUID(
					ДопСвойство.ЗначениеТип,
					ДопСвойство.ЗначениеID);
			КонецЕсли;
			
			ТипСвойства = "DMObject";
			ДоступныеТипы = ДопСвойство.СписокДоступныхТипов;
			Если ДоступныеТипы.Количество() = 1 Тогда
				ТипСвойства = ДоступныеТипы[0].Значение.xdtoClassName;
			КонецЕсли;
			
			ЗначениеСвойства = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
				Прокси,
				ТипСвойства,
				СсылкаНаПотребителя,
				ЭтоОбъектИС);
			
			Если Не ЭтоОбъектИС Тогда
				
				Если ДопСвойство.ЗначениеТип = "Строка" Тогда
					ЗначениеСвойства.externalObject = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьExternalObject(
						Прокси,,
						ДопСвойство.ЗначениеID,
						ДопСвойство.ЗначениеТип,
						ДопСвойство.Значение);
				Иначе
					// Значение является объектом ДО.
					ЗначениеСвойства.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
						Прокси,
						ДопСвойство.ЗначениеID,
						ДопСвойство.ЗначениеТип);
				КонецЕсли;
				
			КонецЕсли;
			
			ДополнительноеСвойство.propertyObjectValue = ЗначениеСвойства;
			
		ИначеЕсли ЗначениеЗаполнено(ДопСвойство.Значение) Тогда
			
			Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ДопСвойство.Значение)) Тогда
				ДополнительноеСвойство.propertySimpleValue = Строка(ДопСвойство.Значение);
			Иначе
				ДополнительноеСвойство.propertySimpleValue = ДопСвойство.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнительныеСвойства = ОбъектXDTO.additionalProperties; // СписокXDTO
		ДополнительныеСвойства.Добавить(ДополнительноеСвойство);
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает видимость кнопки Зарегистрировать на форме документа.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//   ОбъектXDTO - ОбъектXDTO - объект с данными документа.
//
Процедура УстановитьДоступностьРегистрации(Форма, ОбъектXDTO) Экспорт
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(
			ОбъектXDTO, "registrationAvailable") Тогда
		Форма.Элементы.Зарегистрировать.Видимость = ОбъектXDTO.registrationAvailable;
	Иначе
		Форма.Элементы.Зарегистрировать.Видимость = Истина;
	КонецЕсли;
	
	Если Форма.Элементы.Зарегистрировать.Видимость Тогда
		Форма.Элементы.ГруппаРегНомерДата.Подсказка =
			НСтр("ru = 'Для регистрации документа используйте кнопку ""Зарегистрировать"" в командной панели.'");
	Иначе
		Форма.Элементы.ГруппаРегНомерДата.Подсказка = "";
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает значение навигационной ссылки формы на объект Документооборота.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма объекта 1С:Документооборота.
//   НавигационнаяСсылка - ОбъектXDTO, Строка - объект XDTO со свойством objectID.navigationRef, или сама навигационная
//     ссылка в виде строки, значение которой нужно установить в форму.
//
Процедура УстановитьНавигационнуюСсылку(Форма, Знач НавигационнаяСсылка) Экспорт
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(НавигационнаяСсылка, "objectID") Тогда
		НавигационнаяСсылка = НавигационнаяСсылка.objectID.navigationRef;
	КонецЕсли;
	
	Если ТипЗнч(НавигационнаяСсылка) <> Тип("Строка") Или Не ЗначениеЗаполнено(НавигационнаяСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	Форма.АвтоНавигационнаяСсылка = Ложь;
	Форма.НавигационнаяСсылка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1#%2",
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.АдресВебСервиса1СДокументооборот(),
		НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает объект XDTO, соответствующий виду документа, по данным его формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//
// Возвращаемое значение:
//   ОбъектXDTO
//
Функция ВидДокументаXDTOПоФормеДокумента(Форма)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	ВидДокументаID = Форма.ВидДокументаID;
	ВидДокументаТип = Форма.ВидДокументаТип;
	
	Если ЗначениеЗаполнено(ВидДокументаID) И ЗначениеЗаполнено(ВидДокументаТип) Тогда
		ОбъектДляПолученияИзДО = Новый Структура("ID, Тип", ВидДокументаID, ВидДокументаТип);
		Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъектыЗапрос(
			Прокси,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектДляПолученияИзДО));
		
		Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
		Попытка
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
		Исключение
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Вид документа ""%1"" не найден в 1С:Документообороте'"),
				Форма.ВидДокумента);
		КонецПопытки;
		
		documentType = Результат.objects[0];
	Иначе
		documentType = Неопределено;
	КонецЕсли;
	
	Возврат documentType;
	
КонецФункции

// Проверяет возможность создания документа указанного вида не по шаблону, возвращая Истина,
// если таковая возможность есть, и формируя сообщение пользователю со сбросом выбранного им
// вида документа.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа 1С:Документооборота.
//   documentType - ОбъектXDTO - вида документа.
//
// Возвращаемое значение:
//   Булево
//
Функция ПроверитьВозможностьСозданияДокументаНеПоШаблону(Форма, documentType)
	
	Если documentType <> Неопределено
			И ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(documentType, "templateRequired")
			И documentType.templateRequired
			И Форма.ШаблонID = "" Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = СтрШаблон(
			НСтр("ru = 'В настройках вида документа ""%1"" установлен запрет на создание документов не по шаблону.'"),
			Форма.ВидДокумента);
		Сообщение.Поле = "ВидДокумента";
		Сообщение.Сообщить();
		
		Форма.ВидДокументаID = "";
		Форма.ВидДокументаТип = "";
		Форма.ВидДокумента = "";
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли